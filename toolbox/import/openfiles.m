%OPENFILES Open files for a slam or localization experiment.
%   [FILES,PARAMS] = OPENFILES(FILENAME,STARTSTEP) opens the setup
%   file, the data files, and in case of a localization experiment,
%   the map file as specified in the setup file of the experiment
%   FILENAME. Returns the structures FILES and PARAMS. Puts all
%   file position indicators to the appropriate positions such that
%   the experiment starts at STARTSTEP.
%
%   FILES has the following fields
%      FILES.ALLOPEN
%      FILES.MAPFID
%      FILES.MASTERSENSID
%      FILES.SENSOR(i).FID
%      FILES.SENSOR(i).PARAMS
%   
%   ALLOPEN is 1 if all files could have been opened, and 0 other-
%   wise. The array SENSOR contains for each sensor its name NAME,
%   the identifier of the data file FID, the label LABEL with which
%   a line in the file has to start, its temporal downsampling factor
%   TDSF, its spatial downsampling factor SDSF, the flag ISREL which
%   says whether the file contains relative or absolute information,
%   the index string INDEXSTR, the name of the extraction function
%   FUNCNAME and the robot-to-sensor frame transform XS expressed in
%   the robot frame. SENSOR further holds the identifier of the
%   master sensor, MASTERSENSID - the sensor whose measurements
%   triggers a new step -, and the map file identifier MAPFID.
%
%   PARAMS carries all the parameters of the experiment as fields
%   according to the values in the setup file FILENAME The setup
%   file is assumed to be in Matlab syntax such that an evaluation
%   yields the PARAMS structure.
%
%   See also READONESTEP, CLOSEFILES.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function [files,params] = openfiles(setupfname,sstep);

% Constants: default values
DEFNAME  = '';          % default value for sensor name
DEFISREL = 0;           % default value for isrelative flag
DEFTDSF  = 1;           % default value for temporal downsampling factor
DEFSDSF  = 1;           % default value for spatial downsampling factor
DEFXS    = zeros(3,1);  % default value for robot-to-sensor transform
DEFCS    = zeros(3);    % default value for r-to-s transform uncertainty
DEFEXFNC = '';          % default value for extraction function

% Try to open setup file. Check .m extension first and add it if needed
if strcmp(setupfname(end-1:end),'.m'),
  setupfname = setupfname(1:end-2);
end;
setupfid = fopen([setupfname,'.m']);

if setupfid ~= -1,
  err = 0;
  % If o.k. evaluate setup file making the params structure available
  eval(setupfname,'err = 1; errmsg = lasterr;');
  fclose(setupfid);
  
  if ~err,
    
    % Get sensor settings from setup file
    err = 0; i = 1;
    fields = fieldnames(params);
    while (i <= length(fields)) & ~err,
      field = char(fields(i));
      
      if ~isempty(findstr(field,'sensor')),
        % get sensor number, e.g. 2
        snr = str2double(field(length('sensor')+1:end));
        % get full sensor field name, e.g. 'params.sensor2'
        sfieldname = eval(['params.',field]);
        % assign sensor settings
        files.sensor(snr).params = sfieldname;
        % get all subfields
        sfields = fieldnames(sfieldname);
        % open files --> fid's
        j = 1;
        while (j <= length(sfields)) & ~err,
          sfield = char(sfields(j));
          if strcmp(sfield,'datafile'),
            fname = getfield(sfieldname,sfield);
            files.sensor(snr).fid = fopen(fname);
            if files.sensor(snr).fid == -1,
              err = 1; errmsg = ['Data file "',fname,'" not found'];
            end;
          end;
          if strcmp(sfield,'indexstr'),
            str = getfield(sfieldname,sfield);
            files.sensor(snr).params.indexstr = segmentstr(str,',');
          end;
          j = j + 1;
        end;

        % Check whether optional fields are defined
        if ~isfield(files.sensor(snr).params,'name'),
          files.sensor(snr).params.name = DEFNAME;
        end;
        if ~isfield(files.sensor(snr).params,'isrelative'),
          files.sensor(snr).params.isrelative = DEFISREL;
        end;
        if ~isfield(files.sensor(snr).params,'tdownsample'),
          files.sensor(snr).params.tdownsample = DEFTDSF;
        end;
        if ~isfield(files.sensor(snr).params,'sdownsample'),
          files.sensor(snr).params.sdownsample = DEFSDSF;
        end;
        if ~isfield(files.sensor(snr).params,'extractionfnc'),
          files.sensor(snr).params.extractionfnc = DEFEXFNC;
        end;
        if ~isfield(files.sensor(snr).params,'xs'),
          files.sensor(snr).params.xs = DEFXS;
        end;
        if ~isfield(files.sensor(snr).params,'cs'),
          files.sensor(snr).params.cs = DEFCS;
        end;
          
      end;
      i = i + 1;
    end;
    
    if ~err,
      % Write master sensor id field
      if isfield(params,'mastersensid');
        files.mastersensid = params.mastersensid;
        
        % Open map file if specified
        if ~isempty(params.mapfile)
          files.mapfid = fopen(params.mapfile);
          if files.mapfid ~= -1, err = 1; end;
        end;
        
        if ~err,
          % Position file readers according to start step
          files.allopen = 1;
          eof = 0; i = 1;
          while (i < sstep-1) & ~eof,
            [eof,sensors] = readonestep(files);
            i = i + 1;
          end;
          if eof, files.allopen = 0; end;
          
        else
          error('openfiles: Map file not found');
        end;
      else
        error('openfiles: No master sensor defined');
      end;
    else
      error(['openfiles: ',errmsg]);
    end;
  else
    disp(errmsg);
    error('openfiles: Error during evaluation of setup file');
  end;
else
  disp('openfiles: Experiment setup file not found.');
  files.allopen = 0; params = [];
end;