%CLOSEFILES Closes all slam or localization files.
%   CLOSEFILES(FILES) closes all open files in the FILES
%   structure.
%
%   See also OPENFILES.

% v.1.0, Kai Arras, Nov. 2003, CAS-KTH

function closefiles(files);

% Close map file if it exists
if isfield(files,'mapfid')
  fclose(files.mapfid);
end;

% Close all data files
for i = 1:length(files.sensor),
  fclose(files.sensor(i).fid);
end;

% Code says it all...
files.allopen = 0;