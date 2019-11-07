function J = jacobian2(tab, tbc)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function J = jacobian2(tab, tbc)
%
% calculates the jacobian of the composition of a pair 
% of transformations with reespect to the second one.
%-------------------------------------------------------

if length(tab) ~= 3,
   error('Jacobian2: tab is not a transformation!!!');
end

if length(tab) ~= 3,
   error('Jacobian2: tbc is not a transformation!!!');
end

p1 = tab(3);

J = [cos(p1) -sin(p1)  0
     sin(p1)  cos(p1)  0
     0          0      1];
