function [perr,oerr,index,dmin]=get_err(x,path)
%
%   [perr,oerr,index]=get_err(x,path)
%
% A function to compute the position and orientation 
% error of the vehicle with respect to a path

[rows,npath]=size(path);
globals;
dmin=WORLD_SIZE;

for i=1:(npath-1)
   dx=path(1,i)-x(1);
   dy=path(2,i)-x(2);
   d=sqrt(dx*dx + dy*dy);
   if d <= dmin
      dmin=d;
      index=i;
   end
end
dpx=path(1,index+1)-path(1,index);
dpy=path(2,index+1)-path(2,index);
dvx=x(1)-path(1,index);
dvy=x(2)-path(2,index);
perr=dpy*dvx - dpx*dvy;
phiest=atan2(path(2,index+1)-path(2,index),path(1,index+1)-path(1,index));
oerr=(phiest-x(3));