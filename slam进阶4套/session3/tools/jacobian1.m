function J = jacobian1(tab, tbc)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function J = jacobian1(tab, tbc)
%
% calculates the jacobian of the composition of a pair 
% of transformations with respect to the first one.
%-------------------------------------------------------

if length(tab) ~= 3,
   error('Jacobian1: tab is not a transformation!!!');
end

if length(tab) ~= 3,
   error('Jacobian1: tbc is not a transformation!!!');
end

p1 = tab(3);
x2 = tbc(1);
y2 = tbc(2);

J = [1 0 -x2*sin(p1) - y2*cos(p1)
     0 1  x2*cos(p1) - y2*sin(p1)
     0 0  1];
