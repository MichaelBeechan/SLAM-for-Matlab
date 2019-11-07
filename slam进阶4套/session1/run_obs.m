% this is an example run of the vehicle state filter

% initialise global values

globals;
ginit;

% first get all observations 
disp('Beginning observation simulations');
obs=obs_seq(xtrue,beacons);
disp('Completed Simulation');

% place observations in a global coordinate system
[obs_p, state_p]=p_obs(obs,xtrue);
figure(PLAN_FIG);
hold on
plot(obs_p(1,:),obs_p(2,:),'rx');
% plot(state_p(1,:),state_p(2,:),'r+');
hold off
