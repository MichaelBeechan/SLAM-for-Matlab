%GET    Get method for point feature object.
%   V = GET(P,'PropertyName') returns the value of the specified
%   property for the point feature object P.
%
%   GET(P) displays all property names and their current values
%   for the point feature object P.
%
%   Examples:
%      state = get(p,'x');
% 
%   See also: POINTFEATURE/SET.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function val = get(varargin);

switch nargin,
  case 1,
    p = varargin{1};
    if (isa(p,'pointfeature'))
      get(p.entity);
      disp(sprintf('          X = [%s  %s]', num2str(p.x(1)), num2str(p.x(1))));
      disp(sprintf('          C = [%s  %s; %s  %s]', num2str(p.C(1,1)), ...
      num2str(p.C(1,2)), num2str(p.C(2,1)), num2str(p.C(2,2))));
    else
      error('pointfeature/get: Wrong argument type')
    end;
  case 2,
    p = varargin{1};
    prop_name = varargin{2};
    switch lower(prop_name),
      case 'type',
        val = get(p.entity,'type');
      case 'id',
        val = get(p.entity,'id');
      case {'x', 'state'},
        val = p.x;
      case 'c',
        val = p.C;
      otherwise
        error([prop_name,' is not a valid point feature property']);
    end;
  otherwise
    error('pointfeature/get: Wrong number of input arguments')
end