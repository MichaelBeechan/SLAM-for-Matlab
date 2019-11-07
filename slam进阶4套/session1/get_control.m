function [xnext,unext]=get_control(x,u,perr,oerr,dt)
%
% [xnext,unext]=get_control(x,u,perr,oerr)
%
% A function to compute a new control vector for the vehicle
% and to do a one step vehicle prediction with this vector

globals;

unext=zeros(3,1);
xnext=zeros(4,1);

unext(1)=u(1);
unext(2)=KP*perr + KO*(oerr);
unext(3)=u(3)+dt;

xnext(1)=x(1) + dt*unext(1)*cos(x(3)+unext(2));
xnext(2)=x(2) + dt*unext(1)*sin(x(3)+unext(2));
xnext(3)=x(3) + dt*unext(1)*sin(unext(2))/WHEEL_BASE;
xnext(4)=x(4)+dt;
