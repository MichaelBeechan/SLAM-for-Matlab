%SET    Set method for robot object.
%   R = SET(R,'PropertyName',PropertyValue) sets the value of
%   the specified property for the robot object R.
%  
%   R = SET(R,'PropertyName1',PropertyValue1,'PropertyName2',
%   PropertyValue2,...) sets multiple property values with a
%   single statement.
%
%   Note that the assignment to the output R is necessary since
%   Matlab does not support passing arguments by reference.
%   Hence the set method actually operates on a copy of the object.
%
%   SET(R) displays all property names and their possible values 
%   for the robot object R.
%
%   Examples:
%      r = set(r,'Name','Pluto','FormType',4);
% 
%   See also: ROBOT/GET.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function r = set(varargin);

if nargin == 1,
  r = varargin{1};
  if (isa(r,'robot'))
    set(r.entity);
    disp(sprintf('       Name'));
    disp(sprintf('       Time'));
    disp(sprintf('       FormType'));
  else
    error('robot/set: Wrong argument type')
  end;
elseif rem(nargin,2) ~= 0,
  r = varargin{1};
  prop_argin = varargin(2:end);
  while length(prop_argin) >= 2,
    prop_name  = prop_argin{1};
    val        = prop_argin{2};
    prop_argin = prop_argin(3:end);
    switch lower(prop_name),
      case 'id',
        r.entity = set(r.entity,'id',val);
      case 'name',
        r.name = val;
      case {'timestamp','time'},
        r.t = val;
      case 'formtype',
        r.formtype = val;
      otherwise
        error([prop_name,' is not accessible or not a valid robot object property']);
    end;
  end;
else
  error('robot/set: Wrong number of input arguments')
end;