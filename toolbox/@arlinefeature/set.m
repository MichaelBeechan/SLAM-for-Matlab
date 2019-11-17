%SET    Set method for alpha,r-line feature object.
%   L = SET(L,'PropertyName',PropertyValue) sets the value of the
%   specified property for the alpha,r-line feature object L.
%  
%   L = SET(L,'PropertyName1',PropertyValue1,'PropertyName2',
%   PropertyValue2,...) sets multiple property values with a
%   single statement.
%
%   Note that the assignment to the output L is necessary since
%   Matlab does not support passing arguments by reference.
%   Hence the set method actually operates on a copy of the object.
%
%   SET(L) displays all property names and their possible values 
%   for the alpha,r-line feature object L.
%
%   Examples:
%      l = set(l,'x',[pi/6; 2],'C',zeros(2));
% 
%   See also: ARLINEFEATURE/GET.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function l = set(varargin);

if nargin == 1,
  l = varargin{1};
  if (isa(l,'arlinefeature'))
    set(l.entity);
    disp(sprintf('       X: 2x1 vector'));
    disp(sprintf('       C: 2x2 matrix'));
  else
    error('arlinefeature/set: Wrong argument type')
  end;
elseif rem(nargin,2) ~= 0,
  l = varargin{1};
  prop_argin = varargin(2:end);
  while length(prop_argin) >= 2,
    prop_name  = prop_argin{1};
    val        = prop_argin{2};
    prop_argin = prop_argin(3:end);
    switch lower(prop_name),
      case 'type',
        l.entity = set(l.entity, 'type', val);
      case 'id',
        l.entity = set(l.entity, 'id', val);
      case {'x','state'},
        l.x = val;
      case 'c',
        l.C = val;
      otherwise
        error([prop_name,' is not a valid alpha,r-line feature property']);
    end;
  end;
else
  error('arlinefeature/set: Wrong number of input arguments')
end;