function [xest, Pest, innov, S]=update(xpred,Ppred,obs,beacons)
%
% function [xest, Pest, innov, S]=update(xpred,Ppred,obs,beacons)
%
% HDW 3/1/95 Modified 31/05/00
% function to update vehicle location 

globals;

[temp,N_OBS]=size(obs);
if temp ~= 4
  error('observation dimension of 4 expected')
end

[XSIZE,temp]=size(xpred);
if temp ~= 1
  error('xpred expected to be a column vector')
end

[s1,s2]=size(Ppred);
if((s1 ~= XSIZE)|(s2 ~=XSIZE))
  error('Ppred not of size XSIZE')
end

sigma_range=SIGMA_RANGE*SIGMA_RANGE;
sigma_bearing=SIGMA_BEARING*SIGMA_BEARING;

% first put observation in cartesian vehicle-centred coords
zv=[R_OFFSET+(obs(1)*cos(obs(2))); 
    obs(1)*sin(obs(2))];
T=[cos(obs(2)) -sin(obs(2)); 
   sin(obs(2)) cos(obs(2))];
sigma_o=[sigma_range 0; 
         0 sigma_bearing*(obs(1)^2)];
sigma_z=T*sigma_o*T';

% then in base coordinates
zb=[xpred(1)+(zv(1)*cos(xpred(3)))-(zv(2)*sin(xpred(3)));
    xpred(1)+(zv(1)*sin(xpred(3)))+(zv(2)*cos(xpred(3)))];
Tx=[1 0 -((zv(1)*sin(xpred(3)))+(zv(2)*cos(xpred(3)))) 0;
    1 0 -((zv(1)*cos(xpred(3)))+(zv(2)*sin(xpred(3)))) 0];
Tz=[cos(xpred(3)) -sin(xpred(3));
    sin(xpred(3))  cos(xpred(3))];
sigma_b=Tx*Ppred*Tx' + Tz*sigma_z*Tz';

% now try and match observation to beacon map 

% index=match(zb,sigma_b,beacons);
index=obs(3);

if (index)
  dx=beacons(index,1)-xpred(1); 
  dy=beacons(index,2)-xpred(2);
  T=[ cos(xpred(3)) sin(xpred(3));
    -sin(xpred(3)) cos(xpred(3))];
  H=[-cos(xpred(3)) -sin(xpred(3)) (-(dx*sin(xpred(3)))+(dy*cos(xpred(3)))) 0;
      sin(xpred(3)) -cos(xpred(3)) (-(dx*cos(xpred(3)))-(dy*sin(xpred(3)))) 0];
  zpred=T*[dx;dy];
  S=H*Ppred*H' + sigma_z;
  W=Ppred*H'* inv(S);
  Pest=Ppred-W*S*W';
  innov=[zv(1)-zpred(1); zv(2)-zpred(2)];
  xest=xpred+W*innov;
else
  xest=xpred;
  Pest=Ppred;
  S=zeros(2,2);
  innov=zeros(2,1);
end

