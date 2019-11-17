%INTEGRATE Add alpha,r-line feature to the map.
%   [LW,GR] = INTEGRATE(L,XR,CR) transforms the alpha,r-line feature
%   L represented in the robot frame into the world frame given the
%   uncertain 3x1 robot pose XR and the 3x3 pose covariance matrix
%   CR. Returns L expressed in the world frame, LW, and the Jacobian
%   of the integration function, GR. 
%
%   See also ARLINEFEATURE/PREDICT.

% v.1.0, Dec. 2003, Kai Arras, CAS-KTH

function [lw,Gr] = integrate(l,xr,Cr);

if isa(l,'arlinefeature') & (prod(size(xr))==3) & (size(Cr)==[3 3]),

  % First moment
  alphaR = l.x(1);
  rR = l.x(2);
  alphaW = setangletorange(alphaR + xr(3),0);
  angsum = alphaR + xr(3);
  rW = rR + xr(1)*cos(angsum) + xr(2)*sin(angsum);
  
	% Gr: 2x3 Jacobian with respect to the xr
	Gr(1,1) = 0;
	Gr(1,2) = 0;
	Gr(1,3) = 1;
	Gr(2,1) = cos(angsum);
	Gr(2,2) = sin(angsum);
	Gr(2,3) = xr(2)*cos(angsum) - xr(1)*sin(angsum);
  
	% Gnew: 2x2 Jacobian with respect to the observed line l
	Gnew(1,1) = 1;
	Gnew(1,2) = 0;
	Gnew(2,1) = Gr(2,3);
	Gnew(2,2) = 1;
	
  % Second moment
  Cnew = get(l,'c');
	ClinW = Gr*Cr*Gr' + Gnew*Cnew*Gnew';

  % Assignment
  lw = arlinefeature(l);
  lw.x = [alphaW; rW];
  lw.C = ClinW;
  
else
  disp('arlinefeature/integrate: Wrong input. Check your arguments');
end;