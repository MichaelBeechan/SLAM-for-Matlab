function Pa = tpcomp (Tab, Pb),
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function Pa = tpcomp (Tab, Pb),
%
% Composition of a transformation and a set of points
%-------------------------------------------------------
s = sin(Tab(3));
c = cos(Tab(3));
Pa = [Tab(1) + [c -s]*Pb
      Tab(2) + [s  c]*Pb];
