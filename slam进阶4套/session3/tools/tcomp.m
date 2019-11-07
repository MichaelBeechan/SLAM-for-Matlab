function tac= tcomp (tab, tbc),
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function tac= tcomp (tab, tbc),
%
% composes two transformations tab and tbc
%-------------------------------------------------------

if size(tab,1) ~= 3,
   error('TCOMP: tab is not a transformation!!!');
end;

if size(tbc,1) ~= 3,
   error('TCOMP: tbc is not a transformation!!!');
end;

result = tab(3)+tbc(3);

if result > pi | result <= -pi
   result = normalize(result) ;
end

s = sin(tab(3));
c = cos(tab(3));
tac = [tab(1:2)+ [c -s; s c]*tbc(1:2);
       result];