%ROBOT Constructor function for robot object.
%   R = ROBOT
%   Creates a new robot object with default values.
%
%   R = ROBOT(R)
%   Copies and returns the robot object R.
%
%   R = ROBOT(TYPESTR,NAME,FORMTYPE,T)
%   Creates a new robot object with values
%    TYPESTR : type string
%       NAME : name string
%   FORMTYPE : form type identifier according to DRAWROBOT
%          T : discrete time index or timestamp
%
%   The robot class is a child class of the base class ENTITY
%   and in turn base class for all robot classes.
%
%   Example:
%      r = robot('differential drive robot',1,'Piggy',4,now);
%
%   See also ENTITY, ROBOTDD, DRAWROBOT.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function r = robot(varargin);

switch nargin,
  case 0,
    % if no input arguments, create a default object
    r.name = '';
    r.formtype = 0;
    r.t = 0;
    e = entity('robot',0);
    r = class(r,'robot',e);
  case 1,
    % if single argument of class robot, return it
    if (isa(varargin{1},'robot'))
      r = varargin{1}; 
    else
      error('robot: Input argument not a robot object')
    end
  case 4,
    % create object using specified values
    r.name = varargin{2};
    r.formtype = varargin{3};
    r.t = varargin{4};
    e = entity(varargin{1},0);  % robots have id = 0 per default
    r = class(r,'robot',e);
  otherwise
    error('robot: Wrong number of input arguments')
end