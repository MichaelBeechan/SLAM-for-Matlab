function path=get_path(beacons)
%
%  path=get_path(beacons)
%
% HDW 28/04/00
% Function to graphically acquire spline points
% and compute spline fit path for vehicle
% plan is in integer figure handle
% beacons is a 2*N array of x,y beacon locations
% path is a 2*M array of x,y path points
% get_path uses a call to 'globals' for various fixed values
% set up the figure

globals;
figure(PLAN_FIG)
clf
v=[0 WORLD_SIZE 0 WORLD_SIZE];
axis(v);
hold on;
plot(beacons(:,1),beacons(:,2),'go')
pin=1;
npoints=0;
points=zeros(2,1);
xi=[];

% get input points graphically 
% and then set up basis x values
% interpolation can get confused so be careful !
while pin
   [x,y]=ginput(1);
   pin= ~isempty(x);
   if pin
      npoints=npoints+1;
      plot(x,y,'rx')
      points(1,npoints)=x;
      points(2,npoints)=y;
      % now find a basis for x
      if npoints > 1
   	   dx=points(1,npoints)-points(1,npoints-1);
      	dy=points(2,npoints)-points(2,npoints-1);
      	length=sqrt(dx*dx + dy*dy);
      	xincs=points(1,npoints-1):LINC*dx/length:points(1,npoints);
      	xi=[xi xincs];
      end
   end
end
% now we have all the basis points, interpolate the
% path in y. A better method would be to do this along
% the arc length; would need to think how to do this !
yi=interp1(points(1,:),points(2,:),xi,'spline');
plot(xi,yi,'r')
path=[xi;yi];
hold off
