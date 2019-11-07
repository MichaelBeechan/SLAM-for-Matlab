function draw_reference (Xwr, color)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function draw_reference (Xwr, color)
%
% draws a reference system in Xwr
%-------------------------------------------------------

Xrx = [0.5;0;0];
Xry = [0;0.5;0];
Xwx = tcomp(Xwr, Xrx);
Xwy = tcomp(Xwr, Xry);
plot([Xwr(1) Xwx(1)],[Xwr(2) Xwx(2)], color);
plot([Xwr(1) Xwy(1)],[Xwr(2) Xwy(2)], color);
%text(Xwx(1),Xwx(2),'x');
%text(Xwy(1),Xwy(2),'y');
