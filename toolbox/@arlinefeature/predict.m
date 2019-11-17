%PREDICT Measurement prediction of alpha,r-line features.
%   [LR,HR,HM] = PREDICT(L,XR,CR,CRL) transforms the alpha,r-line
%   feature L represented in the world frame into the robot frame
%   given the uncertain robot pose XR, CR, and the cross-corre-
%   lation between the robot and L, CRL. XR is 3x1 vector, CR a
%   3x3 covariance matrix and CRL a 3x2 cross-correlation matrix.
%   The function returns the predicted line feature LR, the 2x3
%   measurement Jacobian derived with respect to the robot, HR,
%   and the 2x2 measurement Jacobian with respect to L, HM.
%
%   See also ARLINEFEAETURE/INTEGRATE.

% v.1.0, Dec. 2003, Kai Arras, CAS-KTH

function [lr,Hr,Hm] = predict(l,xwr,Cr,Crl);

if isa(l,'arlinefeature') & (prod(size(xwr))==3) & ...
      (size(Cr)==[3 3])  & (size(Crl)==[3 2]),

  % First moment
  alphaW = l.x(1);
  rW = l.x(2);
  rR = rW - xwr(1)*cos(alphaW) - xwr(2)*sin(alphaW) ;
  alphaR = setangletorange(alphaW-xwr(3), 0);

  % Hr: 2x3 measurement Jacobian with respect to the robot xr
  Hr(1,1) =  0;
  Hr(1,2) =  0;
  Hr(1,3) = -1;
  Hr(2,1) = -cos(alphaW);
  Hr(2,2) = -sin(alphaW);
  Hr(2,3) =  0;

  % Hm: 2x2 measurement Jacobian with respect to model feature xm
  Hm(1,1) = 1;
  Hm(1,2) = 0;
  Hm(2,1) = xwr(1)*sin(alphaW)-xwr(2)*cos(alphaW); 
  Hm(2,2) = 1;

  % Second moment
  Clinr = Hr*Cr*Hr' + Hr*Crl*Hm' + Hm*Crl'*Hr' + Hm*l.C*Hm';
  
  % Assignment
  lr = arlinefeature(l);
  lr.x = [alphaR;rR];
  lr.C = Clinr;

else
  disp('arlinefeature/predict: Wrong input. Check your arguments');
end;