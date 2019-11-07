function [obs,b]=rad_sim(start_loc,end_loc,beacons)

%
% [obs,b]=rad_sim(start_loc,end_loc,beacons)
%
% HDW 15/12/94, modified 17/05/00
% function to simulate radar observations
% takes a start and end location for the vehicle,
% the vehicle parameter set and a map of beacons. 
% Returns an observation if one is made during this
% time slot.

% output observation vector is a row vector containing
% range, bearing and index.

globals;

obs=zeros(4,1);

% The location vectors start_loc and end_loc each consist 
% of a vector of x,y,phi,t, describing the location of the 
% vehicle at a specific time.
[XSIZE,temp]=size(start_loc);
if((XSIZE ~= 4)+(temp ~= 1))
  error('Incorrect size for start_loc')
end
[XSIZE,temp]=size(end_loc);
if((XSIZE ~= 4)+(temp ~= 1))
  error('Incorrect size for end_loc')
end


% The beacon map consists of an array of x,y locations
% for the beacons 
[N_BEACONS,temp]=size(beacons);
if (temp ~= 2)
  error('Incorrect Size for beacon map')
end



% The algorithm now proceeds by finding the two bounding
% lines from radar to max range. If the beacon lies between these
% two lines, then it will be observed

% first find location and aim of radar at start and end 
radx1=start_loc(1) + (R_OFFSET*cos(start_loc(3)));
rady1=start_loc(2) + (R_OFFSET*sin(start_loc(3)));
radphi1=a_add(start_loc(4)*R_RATE,0.0); % gets normalized angle 
radx2=end_loc(1) + (R_OFFSET*cos(end_loc(3)));
rady2=end_loc(2) + (R_OFFSET*sin(end_loc(3)));
radphi2=a_add(end_loc(4)*R_RATE,0.0); % gets normalized angle 

% construct line segments for checking beacon view
dx1=R_MAX_RANGE*cos(radphi1+start_loc(3));
dy1=R_MAX_RANGE*sin(radphi1+start_loc(3));
dx2=R_MAX_RANGE*cos(radphi2+end_loc(3));
dy2=R_MAX_RANGE*sin(radphi2+end_loc(3));


% To be observed, the beacon must lie between these two lines
% the test is simply that the dot products are positive and
% negative respectively. The nearest beacon within max range is
% recorded.
range=R_MAX_RANGE;
b=0;
for i=1:N_BEACONS
  r=sqrt((beacons(i,1)-radx1)^2+(beacons(i,2)-rady1)^2);
  d1=((beacons(i,2)-rady1)*dx1) - ((beacons(i,1)-radx1)*dy1);
  d2=((beacons(i,2)-rady2)*dx2) - ((beacons(i,1)-radx2)*dy2);
  if((r<R_MAX_RANGE)*(d1>0)*(d2<0)*(r<range)) 
     range=r;
     b=i;
  end	
end

% if a beacon is found, assume it was seen from start_loc:
if b>0
  obs(1)=sqrt((radx1-beacons(b,1))^2+(rady1-beacons(b,2))^2);
  obs(2)=a_sub(atan2(beacons(b,2)-rady1,beacons(b,1)-radx1),start_loc(3));
  obs(3)=b; % beacon index
  obs(4)=start_loc(4); % time stamp
  % noise model
  obs(1)=obs(1)+ GSIGMA_RANGE*randn(size(obs(1)));
  obs(2)=obs(2)+ GSIGMA_BEARING*randn(size(obs(2)));
else
  obs(1)=0.0;
  obs(2)=0.0;
  obs(3)=0;
  obs(4)=0;
end


