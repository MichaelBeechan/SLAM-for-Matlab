function draw_hypothesis (H, features, observations, vehicle, color)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function draw_hypothesis (H, features, observations, vehicle, color)
%
% draw the observations in the absolute reference given
% the vehicle location, and join them by lines with their
% paired features according to hypothesis H
%-------------------------------------------------------
global calculations;
global configuration;

hyp = sprintf('%4d', H);
title (['H: [' hyp ']']);

%draw vehicle
draw_vehicle(vehicle, color);

% observations
observations = transform_observations (observations, vehicle);

% draw all observations
x = observations.z(1:2:end);
y = observations.z(2:2:end);
plot(x, y, [color '.']);

if configuration.draw_ellipses
    for p = 1:length(x),
        obs = obtain_observation (observations, p);
        draw_ellipse (obs.z, obs.R, color);
    end
end

if configuration.draw_trunks
    draw_radius(x, y, observations.radius, color);
end

% paired observations
Es = find (H);
xe = observations.z(2 * (Es - 1) + 1);
ye = observations.z(2 * (Es - 1) + 2);
plot(xe, ye, [color '+']);

% paired features
Fs = H(find (H));
xf = features.x(2 * (Fs - 1) + 1);
yf = features.x(2 * (Fs - 1) + 2);

%pairings
for p=1:length(Es),
    plot([xf(p) ; xe(p)], [yf(p), ye(p)], [color '-']);
end
