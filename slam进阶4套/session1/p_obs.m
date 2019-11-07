function [obs_p,state_p]=p_obs(obs,state)

% function to place vehicle centered observations in 
% global coordinates for checking of consistency 

globals;

[emp,OSIZE]=size(obs);
[temp,SSIZE]=size(state);

if (SSIZE ~= OSIZE)
  error('Unmatched state and observation dimensions')
end

obs_p=zeros(2,SSIZE);
state_p=zeros(2,SSIZE);

numobs=0;
for i=1:SSIZE
   if obs(3,i) ~= 0
      numobs=numobs+1;
      obs_p(1,numobs)=state(1,i)+(obs(1,i).*cos(obs(2,i)+state(3,i)));
      obs_p(2,numobs)=state(2,i)+(obs(1,i).*sin(obs(2,i)+state(3,i)));
      state_p(1,numobs)=state(1,i);
      state_p(2,numobs)=state(2,i);
   end
end

obs_p=obs_p(:,1:numobs);
state_p=state_p(:,1:numobs);



