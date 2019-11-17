%INTEGRATE Add point feature to the map.
%   [PW,GR] = INTEGRATE(P,XR,CR) transforms the point feature P re-
%   presented in the robot frame into the world frame given the
%   uncertain 3x1 robot pose XR and the 3x3 pose covariance matrix
%   CR. Returns P expressed in the world frame, PW, and the Jacobian
%   of the integration function, GR. 
%
%   See also POINTFEATURE/PREDICT.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function [pw,Gr] = integrate(p,xwr,Cr);

if isa(p,'pointfeature') & (prod(size(xwr))==3) & (size(Cr)==[3 3]),

  %%% Pose solution
  % --- first moment
  xrp = p.x;
  xrp(3) = 0;
  xpinw1 = compound(xwr,xrp);
  
  % --- second moment
  Cp3  = eye(3,2)*p.C*eye(2,3);   % make it a 3x3 matrix
  
  C = [Cr    zeros(3);
       zeros(3)   Cp3];
  G = [j1comp(xwr,xrp) j2comp(xwr,xrp)];
  Cpinw1 = G*C*G';

  % --- assignment
  pw = pointfeature(p);
  pw.x = xpinw1(1:2,1);
  pw.C = eye(2,3)*Cpinw1*eye(3,2);  % make it a 2x2 matrix
  Gr = G(1:2,1:3);

%   %%% identical coordinates solution (tested)
%   % --- first moment
%   xp = p.x(1); yp = p.x(2);
%   xr = xwr(1); yr = xwr(2); tr = xwr(3);
%   xpinw2 = xp*cos(tr) - yp*sin(tr) + xr;
%   ypinw2 = xp*sin(tr) + yp*cos(tr) + yr;
% 
%   % --- second moment
%   Cp = p.C;
%   Jr = [1 0 -xp*sin(tr) - yp*cos(tr);
%         0 1  xp*cos(tr) - yp*sin(tr)];
%   Jp = [cos(tr) -sin(tr); sin(tr) cos(tr)];
%   Jrp = [Jr  Jp];
%   Cinr = [Cr   zeros(3,2);
%          zeros(2,3)   Cp];
%   Cpinw2 = Jrp*Cinr*Jrp';
%   
%   % --- assignment
%   pw2 = pointfeature(p);
%   pw2.x(1) = xpinw2;
%   pw2.x(2) = ypinw2;
%   pw2.C = Cpinw2;  % make it a 2x2 matrix
%   pw2 = set(pw2,'id',102);
  
else
  disp('pointfeature/integrate: Wrong input. Check your arguments');
end;