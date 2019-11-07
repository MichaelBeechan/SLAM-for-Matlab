function draw_features (features, color)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function draw_features (features, color)
%
% plots the point features, whose coordinates
% appear in features.x
%-------------------------------------------------------
global configuration;

axis equal;
hold on;
title(sprintf('Stochastic map with %d features', features.n));

x = features.x(1:2:end);
y = features.x(2:2:end);

if configuration.draw_trunks
    draw_radius(x, y, features.radius, color);
end

if configuration.draw_ellipses
    for p = 1:length(x),
        feat = obtain_feature (features, p);
        draw_ellipse (feat.x, feat.P, color);
    end
end

plot(x, y, [color '.']);

