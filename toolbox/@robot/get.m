%GET    Get method for robot object.
%   V = GET(R,'PropertyName') returns the value of the specified
%   property for the robot object R.
%
%   GET(R) displays all property names and their current values
%   for the robot object R.
%
%   Examples:
%      state = get(r,'name');
% 
%   See also: ROBOT/SET.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function val = get(varargin);

switch nargin,
  case 1,
    r = varargin{1};
    if (isa(r,'robot'))
      get(r.entity);
      disp(sprintf('       Name = [%s]', r.name));
      disp(sprintf('       Time = [%d]', r.t));
      disp(sprintf('   FormType = [%d]', r.formtype));
   else
      error('robot/get: Wrong argument type')
    end;
  case 2,
    r = varargin{1};
    prop_name = varargin{2};
    switch lower(prop_name),
      case 'type',
        val = get(r.entity,'type');
      case 'id',
        val = get(r.entity,'id');
      case 'name',
        val = r.name;
      case {'timestamp','time'},
        val = r.t;
      case 'formtype',
        val = r.formtype;
      otherwise
        error([prop_name,' is not a valid robot object property']);
    end;
  otherwise
    error('robot/get: Wrong number of input arguments')
end