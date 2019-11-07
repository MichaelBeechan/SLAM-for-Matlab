% A Simple Particle Filter for localization
%
% author : Mike Montemerlo (CMU) (mmde@cs.cmu.edu)
%
% This code depends on the robot trajectory and sensor simulator
% code written by Hugh Durrant-Whyte
%
% First, run set_up
% then, run_obs
% then, run_pfilter
%
% All particle filter parameters are at the top of this file.

globals;

% number of particles 
NUM_PARTICLES         =       100; 

% process every nth observation
PERCEPTION_SKIP       =       5;  

% resample every nth observation processed
RESAMPLE_SKIP         =       4;   

% wait for keyboard returns between resamplings
INTERACTIVE           =       1;

% parameters of robot motion model
SIGMA_VELOCITY        =       0.1;
SIGMA_STEERING        =       0.035;

% parameters of robot sensor model
SIGMA_RANGE           =       0.25;
SIGMA_BEARING         =       (1.0 * pi / 180.0);
SIGMA_RADIUS          =       0.001;

% initialization parameters 
SIGMA_X               =       0.024 * 100;
SIGMA_Y               =       0.024 * 100;
SIGMA_THETA           =       0.00025 * 10;
INITIAL_RADIUS        =       0.30;

% global localization parameters
DO_GLOBAL_LOC         =       0;
GLOBAL_PARTICLES      =       10000;
GLOBAL_FACTOR         =       20.0;

% main program start

% Initialize random number generator
randn('state',sum(100*clock));

% set the number of particles appropriately
if DO_GLOBAL_LOC,
    NUM_P = GLOBAL_PARTICLES;
else
    NUM_P = NUM_PARTICLES;
end

% Initialize particles 
path = zeros(size(obs,2), 4);
drpath = zeros(size(obs,2), 3);
newu = zeros(NUM_P, 3);
tempp = zeros(NUM_P, 4);
dobs = zeros(NUM_P, 2);
weights = ones(NUM_P, 1);

particles=zeros(NUM_P,4);
if DO_GLOBAL_LOC,
    % initialize particles uniformly over configuration space
    particles(:,1) = rand(NUM_P, 1) .* 500; 
    particles(:,2) = rand(NUM_P, 1) .* 500; 
    particles(:,3) = rand(NUM_P, 1) .* (2 * pi) - pi; 
    particles(:,4) = INITIAL_RADIUS + randn(NUM_P, 1) .* SIGMA_RADIUS; 
    SIGMA_RANGE = SIGMA_RANGE * GLOBAL_FACTOR;
    SIGMA_BEARING = SIGMA_BEARING * GLOBAL_FACTOR;
else
    % initialize particles using gaussian
    particles(:,1) = xtrue(1,1) + randn(NUM_P, 1) .* SIGMA_X; 
    particles(:,2) = xtrue(2,1) + randn(NUM_P, 1) .* SIGMA_Y; 
    particles(:,3) = xtrue(3,1) + randn(NUM_P, 1) .* SIGMA_THETA; 
    particles(:,4) = INITIAL_RADIUS + randn(NUM_P, 1) .* SIGMA_RADIUS; 
end

% initialize bookkeeping
drx = xtrue(1,1);
dry = xtrue(2,1);
drtheta = xtrue(3,1);
obs_count = 0;
perception_count = 1;
last_resample = -1;
time = 0;
shrunk = 0;

if INTERACTIVE,
    % draw the results
    figure(1);
    plot(xtrue(1,:),xtrue(2,:),'b');
    hold on
    plot(path(1:i,1),path(1:i,2),'r');    
    plot(particles(:,1),particles(:,2), 'gx');
    plot(beacons(:,1),beacons(:,2),'kx');
    legend('True Path', 'Estimated Path (PF)');
    hold off
    axis([0 500 0 500]);
    disp('Press return to continue');
    pause;
end
       
% loop over all of the actions and observations 
for i=1:size(obs,2),
    % compute delta t
    dt = uz(3,i) - time;
    time = uz(3,i);

    % compute dead reckoning path (for display purposes only)
    tdrx = drx + dt .* INITIAL_RADIUS .* uz(1,i) .* cos(drtheta + uz(2,i));
    tdry = dry + dt .* INITIAL_RADIUS .* uz(1,i) .* sin(drtheta + uz(2,i));
    tdrtheta = drtheta + dt .* INITIAL_RADIUS .* uz(1,i) .* sin(uz(2,i)) / WHEEL_BASE;
    drx = tdrx;
    dry = tdry;
    drtheta = tdrtheta;
    drpath(i,:) = [drx dry drtheta];
    
    % particle filter action update
    newu(:,1) = uz(1,i) + SIGMA_VELOCITY .* randn(NUM_P,1);
    newu(:,2) = uz(2,i) + SIGMA_STEERING .* randn(NUM_P,1);
    newu(:,3) = SIGMA_RADIUS .* randn(NUM_P,1);      
    tempp(:,1) = particles(:,1) + dt .* (particles(:,4) + newu(:,3)) .* newu(:,1) .* cos(particles(:,3) + newu(:,2));
    tempp(:,2) = particles(:,2) + dt .* (particles(:,4) + newu(:,3)) .* newu(:,1) .* sin(particles(:,3) + newu(:,2));
    tempp(:,3) = particles(:,3) + dt .* (particles(:,4) + newu(:,3)) .* newu(:,1) .* sin(newu(:,2)) / WHEEL_BASE;
    tempp(:,4) = particles(:,4) + newu(:,3);
    particles = tempp;        
    
    % particle filter perception update
    if(obs(3,i) ~= 0)
        obs_count = obs_count + 1;
        if rem(obs_count, PERCEPTION_SKIP) == 0,
            dobs(:,1) = (((beacons(obs(3,i),1) - particles(:,1)).^2 + (beacons(obs(3,i),2) - particles(:,2)).^2).^0.5 - obs(1,i)) ./ SIGMA_RANGE;
            dobs(:,2) = (a_sub(a_sub(atan2(beacons(obs(3,i),2) - particles(:,2), beacons(obs(3,i),1) - particles(:,1)), particles(:,3)), obs(2,i))) ./ SIGMA_BEARING;
            weights = weights .* exp(-0.5 * (dobs(:,1).^2 + dobs(:,2).^2));
            if max(weights > 0),
                weights = weights ./ max(weights);
            else
                weights(:,1) = 1.0;
            end
            perception_count = perception_count + 1;
        end    
    end
       
    % keep track of the mean particle
    path(i,:) = mean(particles, 1);
    
    % If global localization is complete, turn the number of particles back down
    % WARNING : THIS IS A COMPLETE HACK
    % See paper by Dieter Fox on Adaptive Particle Filters for the real way to do this
    if DO_GLOBAL_LOC & std(particles(:,1)) < 10.0 & ~shrunk,
        NUM_P = NUM_PARTICLES;
        particles = particles(1:NUM_P,:);
        newu = newu(1:NUM_P,:);
        tempp = tempp(1:NUM_P,:);
        dobs = dobs(1:NUM_P,:);
        weights = weights(1:NUM_P,:);
        shrunk = 1;
    end
    
    % particle filter resampling - low variance algorithm
    if rem(perception_count, RESAMPLE_SKIP) == 0 & last_resample ~= perception_count,
        last_resample = perception_count;
        fprintf(1, 'resample at time %d\n', i);        
        weight_sum = sum(weights);
        cumulative_sum = cumsum(weights, 1);
        step_size = weight_sum / NUM_P;
        position = rand * weight_sum;
        which_particle = 1;
        for j = 1:NUM_P,
            position = position + step_size;
           if position > weight_sum
                position = position - weight_sum;
                which_particle = 1;
            end
            while position > cumulative_sum(which_particle)
                which_particle = which_particle + 1;
            end
            tempp(j,:) = particles(which_particle,:);
        end
        particles = tempp;
        weights = ones(NUM_P, 1);

        if INTERACTIVE,
            % draw the results
            figure(1);
            plot(xtrue(1,:),xtrue(2,:),'b');
            hold on
            plot(drpath(1:i,1),drpath(1:i,2),'k--');    
            plot(path(1:i,1),path(1:i,2),'r');    
            plot(particles(:,1),particles(:,2), 'gx');
            plot(beacons(:,1),beacons(:,2),'kx');
            legend('True Path', 'Dead Reckoning', 'Estimated Path (PF)');
            hold off
            axis([0 500 0 500]);
            disp('Press return to continue');
            pause;
        end
    end
end

% draw the results
figure(1)
plot(xtrue(1,:),xtrue(2,:),'b');
hold on
plot(drpath(1:i,1),drpath(1:i,2),'k--');    
plot(path(1:i,1),path(1:i,2),'r');    
plot(particles(:,1),particles(:,2), 'gx');
plot(beacons(:,1),beacons(:,2),'kx');
legend('True Path', 'Dead Reckoning', 'Estimated Path (PF)');
hold off
axis([0 500 0 500]);

err = abs(xtrue' - path);
figure(2)
plot((err(:,1).^2+err(:,2).^2).^0.5)
title('Position Error vs. Time');

