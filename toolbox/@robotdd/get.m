%GET    Get method for differential drive robot object.
%   V = GET(R,'PropertyName') returns the value of the specified
%   property for the differential drive robot object R.
%
%   GET(R) displays all property names and their current values
%   for the differential drive robot object R.
%
%   Examples:
%      state = get(r,'x');
% 
%   See also: ROBOTDD/SET.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function val = get(varargin);

switch nargin,
  case 1,
    r = varargin{1};
    if (isa(r,'robotdd'))
      get(r.robot);
      disp(sprintf('          X = [%s  %s  %s]', num2str(r.x(1)), ...
        num2str(r.x(2)), num2str(r.x(3))));
      disp(sprintf('          C = [%s  %s  %s; %s  %s  %s; %s  %s  %s]', ...
        num2str(r.C(1,1)), num2str(r.C(1,2)), num2str(r.C(1,3)), ...
        num2str(r.C(2,1)), num2str(r.C(2,2)), num2str(r.C(2,3)), ...
        num2str(r.C(3,1)), num2str(r.C(3,2)), num2str(r.C(3,3))));
      disp(sprintf('         Rl = [%s]', num2str(r.rl)));
      disp(sprintf('         Rr = [%s]', num2str(r.rr)));
      disp(sprintf('          B = [%s]', num2str(r.b)));
   else
      error('robotdd/get: Wrong argument type')
    end;
  case 2,
    r = varargin{1};
    prop_name = varargin{2};
    switch lower(prop_name),
      case 'type',
        val = get(r.robot,'type');
      case 'id',
        val = get(r.robot,'id');
      case 'name',
        val = get(r.robot,'name');
      case {'x', 'state'},
        val = r.x;
      case 'c',
        val = r.C;
      case 'b',
        val = r.b;
      case 'rl',
        val = r.rl;
      case 'rr',
        val = r.rr;
      case 'formtype',
        val = get(r.robot,'formtype');
      case {'timestamp', 'time'},
        val = get(r.robot,'timestamp');
      otherwise
        error([prop_name,' is not a valid robot object property']);
    end;
  otherwise
    error('robotdd/get: Wrong number of input arguments')
end