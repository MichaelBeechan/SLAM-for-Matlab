%SET    Set method for map object.
%   M = SET(M,'PropertyName',PropertyValue) sets the value of the
%   specified property for the map object M.
%  
%   M = SET(M,'PropertyName1',PropertyValue1,'PropertyName2',
%   PropertyValue2,...) sets multiple property values with a
%   single statement.
%
%   Note that the assignment to the output M is necessary since
%   Matlab does not support passing arguments by reference.
%   Hence the set method actually operates on a copy of the object.
%
%   SET(M) displays all property names and their possible values 
%   for the map object M.
%
%   Examples:
%      M = set(M,'name','predicted map')
%      M = set(M,'x',X)
% 
%   See also MAP/SETROBOT, MAP/GET, MAP/GETSTATE.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function m = set(varargin);

if nargin == 1,
  m = varargin{1};
  if (isa(m,'map'))
    disp(sprintf('       Name'));
    disp(sprintf('       Time'));
    disp(sprintf('       X: object vector'));
    disp(sprintf('       C: matrix of structure'));
    disp(sprintf('       --- X ---'));
    for i = 1:length(m.C),
      set(m.X{i});
    end;
  else
    error('map/set: Wrong argument type')
  end;
elseif rem(nargin,2) ~= 0,
  m = varargin{1};
  prop_argin = varargin(2:end);
  while length(prop_argin) >= 2,
    prop_name  = prop_argin{1};
    val        = prop_argin{2};
    prop_argin = prop_argin(3:end);
    switch lower(prop_name),
      case 'name',
        m.name = val;
      case {'time','timestamp'},
        m.timestamp = val;
      case 'x',
        m.X = val;
      case 'c',
        m.C = val;
        % Make consistent with feature array
        for i = 1:length(m.X);
          m.X{i} = set(m.X{i},'c',val(i,i).C);
        end;
      otherwise
        error([prop_name,' is not a valid map object property']);
    end;
  end;
else
  error('map/set: Wrong number of input arguments')
end;