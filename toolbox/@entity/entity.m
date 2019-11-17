%ENTITY Constructor function for map entity object.
%   E = ENTITY
%   Creates a new map entity object with default values
%
%   E = ENTITY(E)
%   Copies and returns generic feature E
%
%   E = ENTITY(TYPESTR,ID)
%   Creates a new map entity object with values
%      TYPESTR: type string
%      ID     : identifier, integer
%
%   Examples:
%      e = entity('robot',1);
%      e = entity('line segment',36);
%
%   See also CLASS.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH


function e = entity(varargin);
switch nargin,
  case 0,
    % if no input arguments, create a default object
    e.type = 'none';
    e.id = 0;
    e = class(e,'entity');  
  case 1,
    % if single argument of class feature, return it
    if (isa(varargin{1},'entity'))
      e = varargin{1};
    else
      error('entity: Wrong argument type')
    end;
  case 2,
    % create object using specified values if correct syntax
    if isstr(varargin{1}) & isnumeric(varargin{2}),
      e.type = varargin{1};
      e.id = varargin{2};
      e = class(e,'entity');
    else
      error('entity: Wrong argument syntax');
    end;
  otherwise
    error('entity: Wrong number of input arguments')
end;