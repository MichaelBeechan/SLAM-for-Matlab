%READONELINE Read one line of a sensor data file.
%   S = READONELINE(FID,INDEXEXPR,LABEL) reads one line of a sensor
%   data file referenced by FID which starts with the label string
%   LABEL using the index expressions in INDEXEXPR and returns the
%   data in the structure S. S contains the fields which are refer-
%   enced by a corresponding expression in INDEXEXPR.
%
%   If an end-of-file is encountered, S is -1.
%
%   The files must meet the following requirements: Formatted in
%   plain text with one measurement per line and spaces as separa-
%   tor. Each line starts either by a string and a timestamp or only
%   by a timestamp, followed by an arbitrary number of data.
%
%   INDEXEXPR is a cell array containing a list of valid Matlab array
%   indexing expressions. The number of expressions determines the 
%   number of fields of S. The expressions themselves denote the ele-
%   ments on a line of the sensor file. 1 denotes the first element
%   which is either the label string or the timestamp, 2 denotes the
%   timestamp if there is a label string and the first data element
%   otherwise, 3 denotes the third element on the line etc. INDEXEXPR
%   is obtained by calling SEGMENTSTR with the index strings defined
%   in the setup file as argument. An index string is a comma sepa-
%   rated list of indexing expressions.
%
%   Example:
%      With a file whose lines have the following format
%         SONAR timestamp n phi1 rho1 sigmarho1 phi2 rho2 sigmarho2...
%      and the index string in the setup file
%         '2,3,4:3:end,5:3:end,6:3:end'
%      the function returns the structure S with fields
%         s.time  = timestamp
%         s.data1 = n
%         s.data2 = [phi1 phi2 ... phin]
%         s.data3 = [rho1 rho2 ... rhon]
%         s.data4 = [sigmarho1 sigmarho2 ... sigmarhon]
%
%      With the same file and the index string
%         '1,2,6:3:end'
%      the function returns the structure S with fields
%         s.label = SONAR
%         s.time  = timestamp
%         s.data1 = [sigmarho1 sigmarho2 ... sigmarhon]
%
%   See also READONESTEP, SEGMENTSTR.

% v.1.0, 07.12.03, Kai Arras, CAS-KTH

function sensstruct = readoneline(fid,indexexpr,label);

if fid ~= -1,
  
  % Read line until a valid label is found
  str = fgetl(fid);
  if isstr(str),
    
    exit = 0;
    while ~exit,
      % Extract spaces
      indc = find(str==' ');
      % Delete leading spaces (compare with y = x --> 1:length(indc))
      ilastspace = max(find(indc==1:length(indc)));
      if isempty(ilastspace), ilastspace = 0; end;
      indc = indc(ilastspace+1:end);
      % Determine last index before first non-leading space
      imaxlabel = indc(1)-1;
      % This gives the first element on the line
      labelstr  = str(ilastspace+1:imaxlabel);
      % Check whether element is a string (= not a number)
      if isempty(str2num(labelstr)), islabel = 1;
      % if isnan(str2double(labelstr)), islabel = 1; <-- better but slower
      else islabel = 0; end;
      % Check whether label was found and of not: read new line, test on eof
      if ((islabel & strcmp(labelstr,label))|(~islabel & isempty(label))),
        exit = 1;
      else
        str = fgetl(fid);
        if ~isstr(str), exit = 1; end;
      end;
    end;
  end;
  
  if isstr(str),
    % Get data vector of line
    if islabel,
      inputarr = [-1; sscanf(str(imaxlabel+1:end),'%f')];  % -1 is placeholder for label
    else
      inputarr = sscanf(str,'%f');
    end;
    
    % Write structure sensstruct
    j = 1; timestamped = 0; err = 0;
    for i = 1:length(indexexpr),
      if islabel,
        switch char(indexexpr(i)),
          case '1',
            sensstruct.label = labelstr;
          case '2',
            sensstruct.time = inputarr(2);
            timestamped = 1;
          otherwise
            exestr = ['sensstruct.data',int2str(j),'=inputarr(',char(indexexpr(i)),');'];
            % Have Matlab to check the syntax
            eval(exestr,'err = 1; expri = char(indexexpr(i));');
            j = j + 1;
        end;
      else
        switch char(indexexpr(i)),
          case '1',
            sensstruct.time = inputarr(1);
            timestamped = 1;
          otherwise
            exestr = ['sensstruct.data',int2str(j),'=inputarr(',char(indexexpr(i)),');'];
            % Have Matlab to check the syntax
            eval(exestr,'err = 1; expri = char(indexexpr(i));');
            j = j + 1;
        end;
      end;
    end;
    if err,
      error(['readoneline: Syntax error in index string with expression "',expri,'"']);
      sensstruct = -1; 
    elseif ~timestamped,
      error('readoneline: Error in index string: no timestamp');
      sensstruct = -1; 
    end;
    
  else
    % end-of-file reached
    sensstruct = -1; 
  end;
else
  disp('readoneline: Error: input argument file identifier is -1');
  sensstruct = -1;
end;