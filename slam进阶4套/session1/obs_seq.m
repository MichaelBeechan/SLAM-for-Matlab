function obs=obs_seq(state,beacons)


% HDW 15/12/94, modified 17/05/00
% function to gather a complete observation sequence
% inputs are

globals;

% state vector, containing x,y,phi,t
[XSIZE,N_STATES]=size(state);
if XSIZE ~= 4
  error('Incorrect state dimension')
end

obs=zeros(4,N_STATES);

for i=1:N_STATES-1
  start_loc=state(:,i);
  end_loc=state(:,i+1);
  obs(:,i)=rad_sim(start_loc,end_loc,beacons);
end
