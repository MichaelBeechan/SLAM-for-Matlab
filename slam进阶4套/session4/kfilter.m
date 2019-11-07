function [xest, Pest, xpred, Ppred,innov,innvar]=kfilter(obs,u,xinit,Pinit,beacons)

%
% [xest, Pest, xpred, Ppred,innov,innvar]=kfilter(obs,u,xinit,Pinit,beacons)

% HDW 3/1/95 modified 31/05/00
% complete navigation filter
% each row of obs contains an observation of range bearing and beacon index
% each row of u contains omega gamma and time
% obs and u should have the smae number of rows

globals;

[temp,N_OBS]=size(obs);
if temp ~= 4
  error('observation dimension of 4 expected')
end

[temp,N_U]=size(u);
if temp ~= 3
  error('control input vector of dimension 3 expected')
end
if N_U ~= N_OBS
  error('control and observation sequences of different length')
end

[XSIZE,temp]=size(xinit);
if temp ~= 1
  error('xinit expected to be a column vector')
end

[s1,s2]=size(Pinit);
if((s1 ~= XSIZE)|(s2 ~=XSIZE))
  error('Pinit not of size XSIZE')
end

% make some space
xpred=zeros(XSIZE,N_U);
xest=zeros(XSIZE,N_U);
innov=zeros(2,N_U);
innvar=zeros(2,2,N_U);
Ppred=zeros(XSIZE,XSIZE,N_U);
Pest=zeros(XSIZE,XSIZE,N_U);
% returns from pred and update are in the form of column vectors

xe=xinit;
Pe=Pinit;
time=0;
for i=1:N_OBS
   dt=u(3,i)-time;
   time=u(3,i);
   [xp Pp]=pred(xe,Pe,dt,u(:,i));
   [xe Pe in ins]=update(xp,Pp,obs(:,i),beacons);
   xpred(:,i)=xp;
   xest(:,i)=xe;
   innov(:,i)=in;
   Ppred(:,:,i)=Pp;
   Pest(:,:,i)=Pe;
   innvar(:,:,i)=ins;
end

