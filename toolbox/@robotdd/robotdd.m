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
%   R = ROBOTDD(PARAMS)
%   Creates a new differential drive robot object from the
%   fields of the structure PARAMS. PARAMS has the arguments
%   from above as fields .NAME,.X,.C,.RL,.RR,.B,...
%   If PARAMS does not contain all required fields, an error
%   message is returned.
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

% Constants: default values
DEFX  = zeros(3,1);  % default initial robot pose
DEFC  = zeros(3);    % default initial robot pose cov.
DEFRL = 0.08;        % default radius of left wheel in [m]
DEFRR = DEFRL;       % default radius of right wheel in [m]
DEFB  = 0.4;         % default wheelbase in [m]
DEFT  = 0;           % default initial timestamp
DEFNAME = '';        % default robot name
DEFFORM = 0;         % default robot form type

switch nargin,
  case 0,
    % if no input arguments, create a default object
    r.x  = DEFX;
    r.C  = DEFC;
    r.rl = DEFRL;
    r.rr = DEFRR;
    r.b  = DEFB;
    rb = robot('differential drive robot',DEFNAME,DEFFORM,DEFT);
    r  = class(r,'robotdd',rb);      
  case 1,
    if isa(varargin{1},'robotdd'),
      % if single argument of class robotdd, return it
      r = varargin{1}; 
    elseif isstruct(varargin{1}),
      % if structure, get fields, create object
      p = varargin{1};
      if isfield(p,'name'), rname = p.name;
      else rname = DEFNAME; end;
      if isfield(p,'x'), r.x = p.x;
      else r.x = DEFX; end;
      if isfield(p,'c'), r.C = p.c;
      elseif isfield(p,'C'), r.C = p.C;
      else r.C = DEFC; end;
      if isfield(p,'rl'), r.rl = p.rl;
      else r.rl = DEFRL; end;
      if isfield(p,'rr'), r.rr = p.rr;
      else r.rr = DEFRR; end;
      if isfield(p,'b'), r.b = p.b;
      else r.b = DEFB; end;
      if isfield(p,'formtype'), rformtype = p.formtype;
      else rformtype = DEFFORM; end;
      if isfield(p,'time'), rtime = p.time;
      elseif isfield(p,'timestamp'), rtime = p.timestamp;
      else rtime = DEFT; end;
      rb = robot('differential drive robot',rname,rformtype,rtime);
      r  = class(r,'robotdd',rb);      
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