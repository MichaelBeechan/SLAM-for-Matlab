%MAP    Constructor function for map object.
%   M = MAP
%   Creates a new map object with default values
%
%   M = MAP(M)
%   Copies and returns map M
%
%   M = MAP(NAME,T)
%   Creates a new map object with values
%      NAME : map name as a string
%         T : discrete time index or timestamp
%
%   Map is a container class for the map entity base class
%   and its child classes.
%
%   Examples:
%      G = map('global map',now)
%
%   See also ENTITY, CLASS.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function m = map(varargin)

switch nargin,
  case 0,
    % if no input arguments, create a default object
    m.name = 'none';
    m.timestamp = 0;
    m.X = [];
    m.C = [];
    m = class(m,'map');
  case 1,
    % if single argument of class map, return it
    if (isa(varargin{1},'map'))
      m = varargin{1}; 
    else
      error('map: Wrong argument type')
    end
  case 2,
    % create object using specified values if correct syntax
    if isstr(varargin{1}) & isnumeric(varargin{2}),
      m.name = varargin{1};
      m.timestamp = varargin{2};
      m.X = [];
      m.C = [];
      m = class(m,'map');
    else
      error('map: Wrong argument syntax');
    end;
  otherwise
    error('map: Wrong number of input arguments');
end;