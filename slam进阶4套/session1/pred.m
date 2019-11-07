function [xpred, Ppred]=pred(xest,Pest,dt,u)
%
%[xpred, Ppred]=pred(xest,Pest,dt,u)
%
% HDW 16/12/94 modified 31/05/00
% Function to generate a one-step vehicle prediction from 
% previous estimate and control input.


% definitions and checks

globals;

[XSIZE,temp]=size(xest);
if temp ~= 1
  error('xest expected to be a column vector')
end

[s1,s2]=size(Pest);
if((s1 ~= XSIZE)|(s2 ~=XSIZE))
  error('Pest not of size XSIZE')
end

% set parameters
B=WHEEL_BASE;
% SD's to variances */
sigma_q=SIGMA_Q*SIGMA_Q;
sigma_w=SIGMA_W*SIGMA_W;
sigma_s=SIGMA_S*SIGMA_S;
sigma_g=SIGMA_G*SIGMA_G;
sigma_r=SIGMA_R*SIGMA_R; % wheel radius variance

% make some space
xpred=zeros(XSIZE,1);
Ppred=zeros(XSIZE,XSIZE);


% first state prediction
xpred(1)=xest(1) + dt*xest(4)*u(1)*cos(xest(3)+u(2));
xpred(2)=xest(2) + dt*xest(4)*u(1)*sin(xest(3)+u(2));
xpred(3)=xest(3) + dt*xest(4)*u(1)*sin(u(2))/B; 
xpred(4)=xest(4);

% state transition matrix evaluation
F=[1 0 -dt*xest(4)*u(1)*sin(xest(3)+u(2)) dt*u(1)*cos(xest(3)+u(2));
   0 1  dt*xest(4)*u(1)*cos(xest(3)+u(2)) dt*u(1)*sin(xest(3)+u(2));
   0 0         1                           dt*u(1)*sin(u(2))/B;                   
   0 0         0                                 1          ];
   
% source error transfer matrix
G=dt*[cos(xest(3)+u(2)) -sin(xest(3)+u(2)) 0;
   sin(xest(3)+u(2))  cos(xest(3)+u(2)) 0;
   sin(u(2))/B        cos(u(2))/B  0;
         0                  0           1];

% source error covariance
sigma=[(sigma_q*(xest(4)*u(1))^2)+(sigma_w*(xest(4))^2) 0 0;
       0 (sigma_s*(xest(4)*u(1)*u(2))^2)+(sigma_g*(xest(4)*u(1))^2) 0;
       0                        0                              sigma_r];
    
    
% stabalistation noise 
    
stab=[0.000 0 0 0; 0 0.000 0 0; 0 0 0 0; 0 0 0 0];
% Now compute prediction covariance
Ppred=F*Pest*F' + G*sigma*G'+stab;


