%SET    Set method for map entity object.
%   E = SET(E,'PropertyName',PropertyValue) sets the value of the
%   specified property for the map entity object E.
%
%   Note that the assignment to the output E is necessary since 
%   Matlab does not support passing arguments by reference. Hence
%   the set method actually operates on a copy of the object.
%
%   SET(E) displays all property names and their possible values
%   for the map entity object E.
%
%   Examples:
%      e = set(e,'Id',201);
% 
%   See also ENTITY/GET.

% v.1.0, K.O. Arras, Nov. 2003, CAS-KTH


function e = set(varargin);

if nargin == 1,
  e = varargin{1};
  if (isa(e,'entity'))
    disp(sprintf('       Type'));
    disp(sprintf('       ID'));
  else
    error('entity/set: Wrong argument type')
  end;
elseif rem(nargin,2) ~= 0,
  e = varargin{1};
  prop_argin = varargin(2:end);
  while length(prop_argin) >= 2,
    prop_name  = prop_argin{1};
    val        = prop_argin{2};
    prop_argin = prop_argin(3:end);
    switch lower(prop_name),
      case 'type',
        e.type = val;
      case 'id',
        e.id = val;
    otherwise
      error([prop_name,' is not a valid map entity property']);
    end;
  end;
else
  error('entity/set: Wrong number of input arguments')
end;