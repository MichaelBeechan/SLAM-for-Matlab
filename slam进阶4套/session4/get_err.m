function [perr,oerr,index,dmin]=get_err(x,path,prev_idx)
%
%   [perr,oerr,index]=get_err(x,path,last_pt)
%
% A function to compute the position and orientation 
% error of the vehicle with respect to a path.
%
% prev_idx is the index of the point in the path the
% vehicle was closest too the previous time step.
%
% If the vehicle follows the track with reasonable accuracy,
% the index of the closest point for the current time step
% will always be ahead of, or equal to, the previous index.
% In addition, the distance between the vehilce and the path
% should monotonically decrease as the index is incremented
% from prev_idx to the closest point on the path.  After this
% point, all subsequent indexs will result in an increased
% distance between the vehilce and the path.

[rows,npath]=size(path);
globals;

%dmin=WORLD_SIZE;
%dmin=WORLD_SIZE*WORLD_SIZE;
dx=path(1,prev_idx)-x(1);
dy=path(2,prev_idx)-x(2);
dmin=dx*dx + dy*dy;
index = prev_idx;

for i=prev_idx+1:(npath-1)
	dx=path(1,i)-x(1);
	dy=path(2,i)-x(2);

%	d=sqrt(dx*dx + dy*dy);
	d=dx*dx + dy*dy;
   
	if d <= dmin
		dmin=d;
		index=i;
	else
		break;
	end
end
dmin = sqrt(dmin);

dpx=path(1,index+1)-path(1,index);
dpy=path(2,index+1)-path(2,index);
dvx=x(1)-path(1,index);
dvy=x(2)-path(2,index);
perr=dpy*dvx - dpx*dvy;
phiest=atan2(path(2,index+1)-path(2,index),path(1,index+1)-path(1,index));
oerr=(phiest-x(3));