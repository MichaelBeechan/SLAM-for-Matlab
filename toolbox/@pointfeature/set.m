%SET    Set method for point feature object.
%   P = SET(P,'PropertyName',PropertyValue) sets the value of the
%   specified property for the point feature object P.
%  
%   P = SET(P,'PropertyName1',PropertyValue1,'PropertyName2',
%   PropertyValue2,...) sets multiple property values with a
%   single statement.
%
%   Note that the assignment to the output P is necessary since
%   Matlab does not support passing arguments by reference.
%   Hence the set method actually operates on a copy of the object.
%
%   SET(P) displays all property names and their possible values 
%   for the point feature object P.
%
%   Examples:
%      p = set(p,'x',[-1; 2],'C',zeros(2));
% 
%   See also: POINTFEATURE/GET.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function p = set(varargin);

if nargin == 1,
  p = varargin{1};
  if (isa(p,'pointfeature'))
    set(p.entity);
    disp(sprintf('       X: 2x1 vector'));
    disp(sprintf('       C: 2x2 matrix'));
  else
    error('pointfeature/set: Wrong argument type')
  end;
elseif rem(nargin,2) ~= 0,
  p = varargin{1};
  prop_argin = varargin(2:end);
  while length(prop_argin) >= 2,
    prop_name  = prop_argin{1};
    val        = prop_argin{2};
    prop_argin = prop_argin(3:end);
    switch lower(prop_name),
      case 'type',
        p.entity = set(p.entity, 'type', val);
      case 'id',
        p.entity = set(p.entity, 'id', val);
      case {'x','state'},
        p.x = val;
      case 'c',
        p.C = val;
      otherwise
        error([prop_name,' is not a valid point feature property']);
    end;
  end;
else
  error('pointfeature/set: Wrong number of input arguments')
end;