function [ok, vehicle] = is_consistent (H, features, observations)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function ok = is_consistent (H, features, observations)
%
% Determine whether the vehicle location corresponding to
% hypothesis H between observations and features, is
% consistent.
%-------------------------------------------------------
global configuration;

[vehicle, ok] = estimate_vehicle_location (H, features, observations);

% A cheaper, but less tight, consistency verification algorithm:
%
% [vehicle, ok] = mean_square_location (H, features, observations);

if configuration.draw_intermediate_hypotheses
    figure(3); clf; axis equal; hold on;
    H
    draw_features (features, 'b');
    draw_hypothesis (H, features, observations, vehicle, 'r');
    if not(ok)
        disp('NON consistent hypothesis!');
    end
    disp('Press return to continue...');
    pause
end