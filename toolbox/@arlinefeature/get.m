%GET    Get method for alpha,r-line feature object.
%   V = GET(L,'PropertyName') returns the value of the specified
%   property for the alpha,r-line feature object L.
%
%   GET(L) displays all property names and their current values
%   for the alpha,r-line feature object L.
%
%   Examples:
%      state = get(l,'x');
% 
%   See also: ARLINEFEATURE/SET.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function val = get(varargin);

switch nargin,
  case 1,
    l = varargin{1};
    if (isa(l,'arlinefeature'))
      get(l.entity);
      disp(sprintf('          X = [%s  %s]', num2str(l.x(1)), num2str(l.x(1))));
      disp(sprintf('          C = [%s  %s; %s  %s]', num2str(l.C(1,1)), ...
      num2str(l.C(1,2)), num2str(l.C(2,1)), num2str(l.C(2,2))));
    else
      error('arlinefeature/get: Wrong argument type')
    end;
  case 2,
    l = varargin{1};
    prop_name = varargin{2};
    switch lower(prop_name),
      case 'type',
        val = get(l.entity,'type');
      case 'id',
        val = get(l.entity,'id');
      case {'x', 'state'},
        val = l.x;
      case 'c',
        val = l.C;
      otherwise
        error([prop_name,' is not a valid alpha,r-line feature property']);
    end;
  otherwise
    error('arlinefeature/get: Wrong number of input arguments')
end