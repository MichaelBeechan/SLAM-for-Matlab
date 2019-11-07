function draw_scan (scan, observations)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function draw_scan (scan, observations)
%
% plots a laser scan and the extracted observations
%-------------------------------------------------------
global configuration;

axis equal;
axis ([-80 80 -80 80]);
hold on;
Mask13 = uint16(2^13 -1) ;
MaskA  = bitcmp(Mask13,16) ;

RR = double(  bitand( Mask13, scan) ) ;
a  = uint16(  bitand( MaskA , scan) ) ;
RR = RR/100 ;
ii = find(RR < 80);
angles = [-180:180]*pi/360;
[x, y] = pol2cart(angles, RR);

light_gray = [.9 .9 .9];
medium_gray = [.5 .5 .5];
white = [1 1 1];
h = rectangle('Curvature', [0 0], 'Position', [-80 -80 160 160]);
set (h, 'EdgeColor', light_gray);
set (h, 'FaceColor', light_gray);
h = fill([x 0], [y 0], white);
set (h, 'EdgeColor', light_gray);
h = plot(x(ii), y(ii), 'Marker', '.', 'MarkerEdgeColor', medium_gray, 'MarkerFaceColor', medium_gray);
set (h, 'Color', white);

vehicle.x = [0 0 0]';
vehicle.P = zeros(3, 3);

%draw vehicle
draw_vehicle(vehicle, 'k');

%draw features
x = observations.z(1:2:end);
y = observations.z(2:2:end);
plot(x, y, 'r.');

if configuration.draw_ellipses
    for p = 1:length(x),
        draw_ellipse ([x(p); y(p)], observations.R(2*p-1:2*p, 2*p-1:2*p), 'r');
    end
end

if configuration.draw_trunks
    draw_radius(x, y, observations.radius, 'r');
end

title(sprintf('Observations: %d', observations.m));