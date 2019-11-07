function draw_observations (observations, color)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function draw_observations (observations, color)
%
% plots the vehicle and observations, whose coordinates
% appear in observations.x.
%-------------------------------------------------------
global configuration;

axis equal; hold on;

%draw vehicle at origin
vehicle.x = [0 0 0]';
vehicle.P = zeros(3,3);
draw_vehicle(vehicle, color);

%draw points
x = observations.z(1:2:end);
y = observations.z(2:2:end);
plot(x, y, [color '.']);

if configuration.ellipses
    for p = 1:length(x),
        obs = obtain_observation (observations, p);
        draw_ellipse (obs.z, obs.R, color);
    end
end

if configuration.trunks
    draw_radius(x, y, observations.r, color);
end