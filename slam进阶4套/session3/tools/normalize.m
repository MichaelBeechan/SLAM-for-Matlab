function angles = normalize(angles)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function angles = normalize(angles)
%
% Normalizes angles to interval (-pi,pi]
%-------------------------------------------------------

%angles = pi - mod(pi-angles, 2*pi);
% Same result, more efficiently:

angles = angles + (2*pi)*floor((pi-angles)/(2*pi));
