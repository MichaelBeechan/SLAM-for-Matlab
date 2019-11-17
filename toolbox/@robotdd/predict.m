%PREDICT Apply odometry model for differential drive robot.
%   [R,FXR,PATH] = PREDICT(R,ENC,PARAMS) 
%   calculates the final pose and final pose covariance matrix given
%   a start pose, a start pose covariance matrix and the angular wheel
%   displacements in ENC. PARAMS contains the robot model and the
%   error growth coefficients.
%
%   Input arguments:
%      R   : differential drive robot object with start pose R.X, R.C
%      ENC : structure with fields
%            ENC.PARAMS.KL: error growth coefficient of left wheel
%            ENC.PARAMS.KR: error growth coefficient of right wheel
%               with unit in [1/m]. 
%            ENC.STEPS(i).DATA1: angular displacements of left wheel
%            ENC.STEPS(i).DATA2: angular displacements of right wheel
%               in [rad] and monotonically increasing
%      PARAMS.B : wheelbase in [m]. Distance between the two wheel
%                 contact points
%      PARAMS.RL: radius of left wheel in [m]
%      PARAMS.RR: radius of right wheel in [m]
%
%   Output arguments:
%      R    : differential drive robot object with final pose R.X, R.C
%      FXR  : 3x3 process model Jacobian matrix linearized with
%             respect to XROUT
%      PATH : array of structure with fields PATH(i).X (3x1) and 
%             PATH(i).C (3x3) which holds the poses and the pose
%             covariance matrices over the path
%
%   The function implements an error model for differential drive
%   robots which models non-systematic odometry errors in the wheel 
%   space and propagates them through the robot kinematics onto the
%   x,y,theta-pose level.
%
%   Reference:
%      K.S. Chong, L. Kleeman, "Accurate Odometry and Error Modelling
%      for a Mobile Robot," IEEE International Conference on Robotics
%      and Automation, Albuquerque, USA, 1997.
%
%   See also SLAM.

% v.1.1, ~2000, Kai Arras, ASL-EPFL, Felix Wullschleger, IfR-ETHZ
% v.1.2, 29.11.2003, Kai Arras, CAS-KTH: toolbox version

function [r,Fxr,path] = predict(r,enc);

global b rl rr kl kr;

% Constants
% Error growth coefficients
kl = enc.params.kl;
kr = enc.params.kr;
% Kinematic parameters
b  = r.b;
rl = r.rl;
rr = r.rr;

nSteps = length(enc.steps);
% Test if enc is empty or contains only one "raw" measurement. The sensor
% is assumed to be relative, i.e. one measurement (angular displacement)
% comes from two "raw" measurements (arbitrary angles from a relative
% encoder), we therefore test with 'nSteps > 2'.
if nSteps > 2,
  % Initialize loop
  from.x = r.x(1); from.y = r.x(2); from.theta = r.x(3);
  from.C = r.C;
  from.posl = enc.steps(1).data1;
  from.posr = enc.steps(1).data2;
  path(1).x = r.x;
  path(1).C = r.C;
  
  % Simulation loop
  
  Facc = eye(3);
  for i = 2:nSteps,
    
    to.posl = enc.steps(i).data1;
    to.posr = enc.steps(i).data2;
    to = step(to,from);
    
    Fxi = eye(3);
    sl = abs(to.posl - from.posl)*rl;
    sr = abs(to.posr - from.posr)*rr;
    Fxi(1,3) = -(sr+sl)/2*sin(from.theta + (sr-sl)/(2*b));
    Fxi(2,3) =  (sr+sl)/2*cos(from.theta + (sr-sl)/(2*b));
    Facc = Facc*Fxi';
    
    from.posl = to.posl; from.posr = to.posr;
    from.x = to.x; from.y = to.y; from.theta = to.theta; 
    from.C = to.C;
    
    % Fill in path array
    path(i).x = [to.x; to.y; to.theta];
    path(i).C = to.C;
  end;
  r.x = [to.x; to.y; to.theta]; 
  r.C = to.C;
  Fxr = Facc';
  
  if det(to.C) < 0 ,	   % C is negative definit -> SHIT!
    disp('--> applyodometrydd: cov negative definite!');
  end;

else  % If isempty(enc),...
  Fxr = eye(3);
  path(1).x = r.x;
  path(1).C = r.C;
end;


function to = step(to,from);

global b rl rr kl kr;

sl = (to.posl - from.posl)*rl;
sr = (to.posr - from.posr)*rr;
dxR = (sr + sl) / 2;
dthetaR = (sr - sl) / b;
dxW = dxR * cos(from.theta + dthetaR/2);
dyW = dxR * sin(from.theta + dthetaR/2);
dthetaW = dthetaR;

% Odometry: second moments. 0 is left, 1 is right 
sl = abs(sl); 
sr = abs(sr); 
k1 = 1 / (2*b);
k2 = (sr + sl)*0.5;
sinK = sin(from.theta + (sr - sl)*k1);
cosK = cos(from.theta + (sr - sl)*k1);

% Apply error model on the level of U(k+1) 
u00 = kl*abs(sl); 	% where u01 = u10 = 0.0 
u11 = kr*abs(sr);

% Update of C, C(k+1|k) = Fx * C(k|k) * Fx' + Fs * U(k+1) * Fs' 
fx02 = -sinK*k2;
fx12 =  cosK*k2;
accu20 = from.C(1,3) + from.C(3,3) * fx02;
accu21 = from.C(2,3) + from.C(3,3) * fx12;
fu00 = +sinK*k1*k2 + cosK*0.5;
fu01 = -sinK*k1*k2 + cosK*0.5;
fu10 = -cosK*k1*k2 + sinK*0.5;
fu11 = +cosK*k1*k2 + sinK*0.5;

to.C(1,1) = from.C(1,1) + fx02 * (from.C(1,3) + accu20) + fu00*fu00*u00 + fu01*fu01*u11;
to.C(1,2) = from.C(1,2) + from.C(1,3) * fx12 + accu21 * fx02 + fu10*fu00*u00 + fu01*fu11*u11;
to.C(1,3) = accu20 + (fu00*u00 - fu01*u11) / b;
to.C(2,1) = to.C(1,2);
to.C(2,2) = from.C(2,2) + fx12 * (from.C(2,3) + accu21) + fu10*fu10*u00 + fu11*fu11*u11;
to.C(2,3) = accu21 + (fu10*u00 - fu11*u11) / b;
to.C(3,1) = to.C(1,3);
to.C(3,2) = to.C(2,3);
to.C(3,3) = from.C(3,3) + (u00 + u11) / (b*b);

% Odometry update here 
to.x = from.x + dxW;
to.y = from.y + dyW;
to.theta = from.theta + dthetaW;
if to.theta >= 2*pi ,
  to.theta = to.theta - 2*pi;
elseif to.theta < 0 ,
  to.theta = to.theta + 2*pi;
end;