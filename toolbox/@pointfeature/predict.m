%PREDICT Measurement prediction of point features.
%   [PR,HR,HM] = PREDICT(P,XR,CR,CRP) transforms the point feature
%   P represented in the world frame into the robot frame given the 
%   uncertain robot pose XR, CR, and the cross-correlation between
%   the robot and P, CRP. XR is 3x1 vector, CR a 3x3 covariance
%   matrix and CRP a 3x2 cross-correlation matrix. The function
%   returns the predicted point feature PR, the 2x3 measurement
%   Jacobian derived with respect to the robot, HR, and the 2x2
%   measurement Jacobian with respect to P, HM.
%
%   See also POINTFEAETURE/INTEGRATE.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function [pr,Hr,Hm] = predict(p,xwr,Cr,Crp);

if isa(p,'pointfeature') & (prod(size(xwr))==3) & ...
      (size(Cr)==[3 3])  & (size(Crp)==[3 2]),

  % pose solution
  % --- first moment
  xwp = p.x;
  xwp(3) = 0;
  xrw = icompound(xwr);
  xpinr1 = compound(xrw,xwp);
  
  % --- second moment
  Cp3  = eye(3,2)*p.C*eye(2,3);   % make it a 3x3 matrix
  Crp3 = Crp*eye(2,3);            % make it a 3x3 matrix
  
  C = [ Cr   Crp3;
       Crp3' Cp3 ];
  J = [j1comp(xrw,xwp)*jinv(xwr) j2comp(xrw,xwp)];
  Cpinr1 = J*C*J';

  % --- assignment
  pr = pointfeature(p);
  pr.x = xpinr1(1:2,1);
  pr.C = eye(2,3)*Cpinr1*eye(3,2);  % make it a 2x2 matrix
  Hr = J(1:2,1:3);
  Hm = J(1:2,4:5);

%   % coordinates solution
%   % --- first moment
%   xp = p.x(1); yp = p.x(2);
%   xr = xwr(1); yr = xwr(2); tr = xwr(3);
%   xpinr2 =  (xp-xr)*cos(tr) + (yp-yr)*sin(tr);
%   ypinr2 = -(xp-xr)*sin(tr) + (yp-yr)*cos(tr);
% 
%   % --- second moment
%   Cp = p.C;
%   Jp = [ cos(tr) sin(tr); -sin(tr) cos(tr)];
%   Jr = [-cos(tr) -sin(tr) -(xp-xr)*sin(tr) + (yp-yr)*cos(tr);
%          sin(tr) -cos(tr) -(xp-xr)*cos(tr) - (yp-yr)*sin(tr)];
%   Jrp = [Jp  Jr];
%   Cinr = [Cp   Crp';
%          Crp  Cr];
%   Cpinr2 = Jrp*Cinr*Jrp';
%   
%   % --- assignment
%   pr = pointfeature(p);
%   pr.x(1) = xpinr2;
%   pr.x(2) = ypinr2;
%   pr.C = Cpinr2;
%   Hr = Jr;
%   Hm = Jp;

else
  disp('pointfeature/predict: Wrong input. Check your arguments');
end;