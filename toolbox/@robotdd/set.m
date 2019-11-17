%SET    Set method for differential drive robot object.
%   R = SET(R,'PropertyName',PropertyValue) sets the value of
%   the specified property for the differential drive robot
%   object R.
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
%   for the differential drive robot object R.
%
%   Examples:
%      r = set(r,'x',[0;1;pi/3],'C',zeros(3));
% 
%   See also: ROBOTDD/GET.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function r = set(varargin);

if nargin == 1,
  r = varargin{1};
  if (isa(r,'robotdd'))
    set(r.robot);
    disp(sprintf('       X: 3x1 vector'));
    disp(sprintf('       C: 3x3 matrix'));
    disp(sprintf('       Rl'));
    disp(sprintf('       Rr'));
    disp(sprintf('       B'));
  else
    error('robotdd/set: Wrong argument type')
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
        r.robot = set(r.robot,'id',val);
      case 'name',
        r.robot = set(r.robot,'name',val);
      case {'x','state'},
        r.x = val;
      case 'c',
        r.C = val;
      case 'b',
        r.b = val;
      case 'rl',
        r.rl = val;
      case 'rr',
        r.rr = val;
      case 'formtype',
        r.robot = set(r.robot,'formtype',val);
      case {'timestamp','time'},
        r.robot = set(r.robot,'timestamp',val);
      otherwise
        error([prop_name,' is not accessible or not a valid differential drive robot property']);
    end;
  end;
else
  error('robotdd/set: Wrong number of input arguments')
end;