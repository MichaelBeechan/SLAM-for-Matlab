function draw_vehicle (vehicle, color)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function draw_vehicle (vehicle, color)
%
% Draw a triangular robot at location vehicle.x
%-------------------------------------------------------

robot_size = 1;

vertices = [1.5 -1 -1 1.5
       0    1 -1  0 ]*robot_size;
vertices = tpcomp(vehicle.x, vertices);
plot(vertices(1,:), vertices(2,:), [color '-']);
%draw_reference (vehicle.x, color);
draw_ellipse (vehicle.x, vehicle.P, color);
