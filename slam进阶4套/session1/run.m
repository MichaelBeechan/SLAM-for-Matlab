
dt=0.1;
TEND=1000*dt;
% initialise
x=[];
u=[];
x(1)=path(1,1);
x(2)=path(2,1);
x(3)=atan2(path(2,2)-path(2,1),path(1,2)-path(1,1));
x(4)=0;
u(1)=4; % velocity set at 2 m/s
u(2)=0;
u(3)=0;
xlog=x;
ulog=u;
perrlog=0;
oerrlog=0;
% loop control
for t=0:dt:TEND
   % find error
   [perr,oerr,index,d]=get_err(x,path);
   % compute next state
   [x,u]=get_control(x,u,perr,oerr,dt);
   xlog=[xlog;x];
   ulog=[ulog;u];
   if d >10
      sprintf('simulation terminating at time %f\n',t)
      break;
   end
   %perrlog=[perrlog;perr];
   %oerrlog=[oerrlog;oerr];
end


