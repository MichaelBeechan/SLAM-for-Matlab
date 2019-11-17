%READONESTEP Read one step from sensor files.
%   [EOF,SENSORS] = READONESTEP(FILES) reads from the sensor data
%   files referenced by the file identifiers in FILES and returns
%   the data in the array of structures SENSORS. The length of
%   SENSORS is given by the number of sensors defined in the setup
%   file of the experiment. EOF is 1 if an end-of-file in at least
%   one of the files is encountered.
%
%   Refer to OPENFILES to see the definition of FILES.
%
%   The function reads from the last position of the file position 
%   indicators up to the next unread timestamp of the sensor which
%   has been defined to be the master sensor by PARAMS.MASTERSENSID.
%   The master sensor gives the "heartbeat" of the experiment and
%   triggers a new step.
%
%   If for a given step there are no data for one of the sensors,
%   its corresponding structure in SENSORS is empty. Use ISEMPTY
%   to test on this.
%
%   The files must meet the following requirements: Formatted in
%   plain text with one measurement per line and spaces as separa-
%   tor. Each line starts either by a string and a timestamp or only
%   by a timestamp, followed by an arbitrary number of data. The way
%   how the data are read in is defined by the index expressions in
%   the strings PARAMS.INDEXSTR1, PARAMS.INDEXSTR2, ...
%
%   PARAMS contains for each sensor temporal and spatial downsample
%   factors PARAMS.TDOWNSMPLE1 (temporal), SDOWNSMPLE1 (spatial)
%   which make READDATA to thin out the data by reading only each
%   TDOWNSMPLE1-th line of the file and each SDOWNSMPLE1-th data in
%   case of vectorized data as specified in the index strings.
%
%   Example:
%      Given two data files with lines formatted as
%         file 1 : ENCODER timestamp left right
%         file 2 : LASER timestamp n x1 y1 x2 y2 ... xn yn
%
%      and the following experimental parameters:
%         params.sensor1.tdownsample = 3
%         params.sensor1.sdownsample = 1
%         params.sensor1.indexstr = '1,2,4,3'
%         params.sensor2.tdownsample = 1
%         params.sensor2.sdownsample = 2
%         params.sensor2.indexstr = '1,2,3,4:2:end,5:2:end'
%         params.mastersensid = 2
%
%      the function returns the array sensors with fields
%         sensors(1).params
%         sensors(1).steps(i).time  = timestamp   
%         sensors(1).steps(i).data1 = right       
%         sensors(1).steps(i).data2 = left     
%
%         sensors(2).params
%         sensors(2).steps.time  = timestamp
%         sensors(2).steps.data1 = n
%         sensors(2).steps.data2 = [x1 x3 ... xn]
%         sensors(2).steps.data3 = [y1 y3 ... yn]
%
%      Only each 3rd line of the first file is read in while of the
%      second file all vectorized data are downsampled by a factor
%      of 2. As sensor 2 is the master sensor, the arrays over time,
%      sensors(i).steps, of all other sensors have length >= 1, where
%      the length is determined by the number of measurements between
%      the last timestamp (encoded in the file position indicator)
%      and the next unread timestamp of the master sensor divided
%      by the temporal downsampling factor.
%
%   See also READONELINE, OPENFILES, CLOSEFILES.

% v.1.0, 07.12.03, Kai Arras, CAS-KTH

function [eof,sensors] = readonestep(files);

err = 0;
% Check whether all files are there
if ~files.allopen,
  err = 1; errmsg = 'not all files are open';
end;

% Who's the master sensor?
if ~err & isfield(files,'mastersensid'),
  masterid = files.mastersensid;
else
  err = 1; errmsg = 'no master sensor defined';
end;

if ~err,
  % Assign sensor settings and parameters
  sensors(masterid).params = files.sensor(masterid).params;
  params = sensors(masterid).params;
  
  % Start read in master sensor file
  % Thin out temporally
  for i = 1:params.tdownsample-1,
    str = fgetl(files.sensor(masterid).fid);
  end;
  ssm = readoneline(files.sensor(masterid).fid,params.indexstr,params.label);
  
  if isstruct(ssm),
    
    % Thin out spatially
    if params.sdownsample > 1,
      fields = fieldnames(ssm);
      for i = 1:length(fields),
        if ~isempty(findstr(char(fields(i)),'data')),
          exestr = ['ssm.',char(fields(i)),' = ssm.', ...
              char(fields(i)),'(1:',int2str(params.sdownsample),':end);'];
          eval(exestr,'');
        end;
      end;
    end;
    
    % Assign output argument of master sensor
    sensors(masterid).steps = ssm;
    
    % Read in all other sensors ~= masterid
    is = 1; eof = 0;
    while (is <= length(files.sensor)) & ~eof,
      if is ~= masterid,
        
        % Get parameters if sensor is
        sensors(is).params = files.sensor(is).params;
        params = files.sensor(is).params;
        % Save file indicator position for rewind
        fidposold = ftell(files.sensor(is).fid);
        % Read one line
        ssij = readoneline(files.sensor(is).fid,params.indexstr,params.label);
        if isstruct(ssij),
          
          % Thin out data if desired ...
          if params.sdownsample > 1,
            fields = fieldnames(ssij);
            for i = 1:length(fields),
              if ~isempty(findstr(char(fields(i)),'data')),
                exestr = ['ssij.',char(fields(i)),' = ssij.', ...
                    char(fields(i)),'(1:',int2str(params.sdownsample),':end);'];
                eval(exestr,'');
              end;
            end;
          end;
          % finished thin out
                    
          % Thin out temporally
          for i = 1:params.tdownsample-1,
            dummy = fgetl(files.sensor(is).fid);
          end;
          
          % Main loop until timestamp match with master sensor
          j = 1;
          while ~eof & (ssij(j).time < ssm.time),
            j = j + 1;
            
            % Save file indicator position for rewind
            fidposold = ftell(files.sensor(is).fid);
            % Read one line
            ss = readoneline(files.sensor(is).fid,params.indexstr,params.label);
            
            if ~isstruct(ss), eof = 1;
            else
              % Thin out data if desired ...
              if params.sdownsample > 1,
                fields = fieldnames(ss);
                for i = 1:length(fields),
                  if ~isempty(findstr(char(fields(i)),'data')),
                    exestr = ['ss.',char(fields(i)),' = ss.', ...
                        char(fields(i)),'(1:',int2str(params.sdownsample),':end);'];
                    eval(exestr,'');
                  end;
                end;
              end;
              
              % ... and copy
              ssij(j) = ss;
              
              % Thin out temporally
              for i = 1:params.tdownsample-1,
                dummy = fgetl(files.sensor(is).fid);
              end;
              
            end;
          end;
          if ~eof & (ssij(j).time >= ssm.time),
            if params.isrelative,
              % Rewind file one line
              fseek(files.sensor(is).fid,-(ftell(files.sensor(is).fid)-fidposold),'cof');
            elseif ssij(j).time > ssm.time,
              % Rewind file one line
              fseek(files.sensor(is).fid,-(ftell(files.sensor(is).fid)-fidposold),'cof');
              % Remove last entry
              if length(ssij) == 1, ssij = [];
              else ssij = ssij(1:end-1); end;
            end;
          end;
                    
          % Assign output argument
          sensors(is).steps = ssij;
        else
          eof = 1;  % end-of-file in sensor file 'is' encountered
        end;
        
      end;
      is = is + 1;
    end;
    if eof,
      for i = is:length(files.sensor), if i ~= masterid, sensors(i).steps = []; end; end;
    end;
  else
    eof = 1; for i = 1:length(files.sensor), sensors(i).steps = []; end;
  end;
else
  error(['readonestep: ',errmsg]);
end;