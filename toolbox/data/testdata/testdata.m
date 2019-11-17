%TESTDATA Script to test import functionality of the navigation toolbox.

nsteps = 6;
clc;
disp(['------------------']);
disp(['--- Testdata.m ---']);
disp(['------------------']);

% sensor 1
files.sensor(1).fid = fopen('testdata.enc');
files.sensor(1).params.label = 'ENC';
files.sensor(1).params.tdownsample = 2;
files.sensor(1).params.sdownsample = 1;
files.sensor(1).params.isrelative = 1;
files.sensor(1).params.indexstr = segmentstr('1,2,3,4',',');
% sensor 2
files.sensor(2).fid = fopen('testdata.scn');
files.sensor(2).params.label = 'LASER';
files.sensor(2).params.tdownsample = 1;
files.sensor(2).params.sdownsample = 1;
files.sensor(2).params.isrelative = 0;
files.sensor(2).params.indexstr = segmentstr('1,2,3,4:2:floor(end/2),5:2:end',',');
% sensor 3
files.sensor(3).fid = fopen('testdata.imu');
files.sensor(3).params.label = 'IMU';
files.sensor(3).params.tdownsample = 1;
files.sensor(3).params.sdownsample = 1;
files.sensor(3).params.isrelative = 0;
files.sensor(3).params.indexstr = segmentstr('1,2,3:4,5:7,9,10',',');
% master sensor
files.mastersensid = 2;
files.allopen = 1;

% go for it...
clear sensors;
for istep = 1:nsteps,
  disp(' ');
  disp(['----- Step ',int2str(istep),' -----']);
  [eof,sensors] = readonestep(files);
  if ~eof,
    for isensor = 1:length(sensors),
      if ~isempty(sensors(isensor).steps),
        disp(' ');
        fields = fieldnames(sensors(isensor).steps);
        for i = 1:length(sensors(isensor).steps),
          for j = 1:length(fields);
            val = getfield(sensors(isensor).steps,{i},char(fields(j)));
            if size(val,1) ~= 1, val = val'; end;
            disp(['sensors(',int2str(isensor),').steps(',int2str(i),').', ...
                char(fields(j)),' = ',num2str(val)]);
          end;
        end;
      else
        disp(['sensors(',int2str(isensor),').steps = []']);
      end;
    end;
  else
    disp('testdata.m: end-of-file encountered');
  end;
end;

% Closing data files
for i = 1:length(files.sensor),
  fclose(files.sensor(i).fid);
end;