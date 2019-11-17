%SEGMENTSTR Extract substrings between separators.
%   EXPR = SEGMENTSTR(STR,SEPARATOR) chops STR into substrings
%   which stand between SEPARATOR where SEPARATOR is assumed to 
%   be a character. EXPR is a cell array constituted by the
%   substrings.
%
%   Examples:
%      segmentstr('1:2:3:end:4:',':') returns a cell array 
%         with fields  '1'  '2'  '3'  'end'  '4'
%
%      segmentstr('   p.j.  harvey   and john parish  ',' ') 
%         returns a cell array with fields  'p.j.'  'harvey'  
%         'and'  'john'  'parish'
%
%   See also READONELINE.

% v.1.0, 07.12.03, Kai Arras, CAS-KTH


function expr = segmentstr(str,separator);

if ~isempty(str) & (length(separator) == 1),
  
  indc  = find(str==separator);                    % find indices of separator
  sindc = [1 indc+1];                              % start-indices of segments
  eindc = [indc-1 length(str)];                    % end-indices of segments
  
  for i=1:length(sindc),
    expr{i} = str(sindc(i):eindc(i));              % chop into subexpressions
  end;
  
  nonem = char({expr{:}})~=' ';                    % make matrix of non-'' entries
  cindc = find(any(nonem,2));                      % find indices of correct entries
  expr  = {expr{cindc}};                           % remove ''-entries
  
else
  expr = {};
end;