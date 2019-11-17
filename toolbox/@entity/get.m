%GET    Get method for map entity object.
%   V = GET(E,'PropertyName') returns the value of the specified
%   property for the map entity object E.
%
%   GET(E) displays all property names and their current values
%   for the map entity object E.
%
%   Examples:
%      identifier = get(e,'Id');
% 
%   See also ENTITY/SET.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH


function val = get(varargin);

switch nargin,
  case 1,
    e = varargin{1};
    if (isa(e,'entity'))
      disp(sprintf('       Type = %s',e.type));
      disp(sprintf('         ID = [%d]',e.id));
    else
      error('entity/get: Wrong argument type')
    end;
  case 2,
    e = varargin{1};
    prop_name = varargin{2};
    switch lower(prop_name),
      case 'type',
        val = e.type;
      case 'id',
        val = e.id;
    otherwise
      error([prop_name,' is not a valid map entity property']);
    end
otherwise
  error('entity/get: Wrong number of input arguments')
end