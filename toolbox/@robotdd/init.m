%ROBOTDD Constructor function for differential drive robot object.
%   R = ROBOTDD
%   Creates a new differential drive robot object with default
%   values.
%
%   R = ROBOTDD(R)
%   Copies and returns the differential drive robot object R
%
%   R = ROBOTDD(NAME,X,C,RL,RR,B,FORMTYPE,T)
%   Creates a new differential drive robot object with values
%       NAME : name string
%          X : 3x1 robot state vector, interpreted as
%              [x y theta] in units [m] [m] [rad]
%          C : 3x3 state covariance matrix
%              [sxx sxy sxt; sxy syy syt; sxt syt stt]
%         RL : radius of left wheel in [m]
%         RR : radius of right wheel in [m]
%          B : wheel base in [m]
%   FORMTYPE : form type identifier according to DRAWROBOT
%          T : discrete time index or timestamp
%
%   The robot reference frame is attached to the center of the
%   wheel base such that the x-axis looks forward.
%
%   The differential drive robot class is a child class of the
%   base class robot.
%
%   Examples:
%      r = robotdd('Piggy',[1,2,pi]',eye(3),.2,.2,.5,4,now);
%
%   See also ENTITY, CLASS, DRAWROBOT.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function r = robotdd(varargin);

switch nargin,
  case 0,
    % if no input arguments, create a default object
    r.x  = zeros(3,1);
    r.C  = zeros(3);
    r.rl = 0.08;
    r.rr = 0.08;
    r.b  = 0.4;
    rb = robot('differential drive robot','',0,0);
    r  = class(r,'robotdd',rb);      
  case 1,
    % if single argument of class robotdd, return it
    if (isa(varargin{1},'robotdd'))
      r = varargin{1}; 
    else
      error('robotdd: Input argument not a differential drive robot object')
    end
  case 8,
    % create object using specified values
    x = varargin{2};
    C = varargin{3};
    if (prod(size(x)) == 3) & (size(C) == [3,3]),
      r.x  = x;
      r.C  = C;
      r.rl = varargin{4};
      r.rr = varargin{5};
      r.b  = varargin{6};
      rb = robot('differential drive robot',varargin{1},varargin{7},varargin{8});
      r  = class(r,'robotdd',rb);
    else
      error('robotdd: Wrong argument syntax');
    end;
  otherwise
    error('robotdd: Wrong number of input arguments')
end


    % set initial pose and pose covariance
    if isfield(params,'xrinit'),
      r = set(r,'x',params.xrinit);
    end;
    if isfield(params,'Crinit'),
      r = set(r,'c',params.Crinit);
    end;
    % set name and formtype
    if isfield(params.robot,'name'),
      r = set(r,'name',params.robot.name);
    end;
    if isfield(params.robot,'formtype'),
      r = set(r,'formtype',params.robot.formtype);
    end;
    % set kinematic parameters
    r = set(r,'rl',params.robot.rl);
    r = set(r,'rr',params.robot.rr);
    r = set(r,'b',params.robot.b);
      
