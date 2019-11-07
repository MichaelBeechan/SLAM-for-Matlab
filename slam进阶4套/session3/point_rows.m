function indices = point_rows(points)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function indices = point_rows(points)
%
% return the indices corresponding to the coordinates
% of points in a location vector (indices of points [2 5] 
% are [3 4 9 10]).
%-------------------------------------------------------

x = 2*points-1;
y = 2*points;
indices = [x; y];
indices = indices(:);