function d = tdist (twa, twb),
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function d = tdist (twa, twb),
%
% Determines the distance between the origins of two
% transformations
%-------------------------------------------------------

d = norm(twa(1:2)-twb(1:2));