% script file to set up a vehicle run for subsequent
% filtering and localisation algorithms
% HDW 28/04/00

globals; 	% define global variables
ginit;  		% set global variables

% first step is to input beacons
disp('Input Beacon Locations via mouse. Press return to end');
beacons=get_beacons;
[n_beacons,temp]=size(beacons);
buf=sprintf('%d Beacons read\n',n_beacons);
disp(buf);

% Next, input path spline points and compute path
disp('Input path spline points via mouse. Press return to end');
path=get_path(beacons);
[temp,n_path]=size(path);
buf=sprintf('%d Path points of total Length %f meters read\n',n_path,n_path*LINC);
disp(buf);
disp('Press Return to continue'); 
pause;

% do controller to build true path and control vectors
% initialise
time=0:DT:TEND;
[temp,tsize]=size(time);

xtrue=zeros(4,tsize);	% needed for reseting between runs
utrue=zeros(3,tsize);	% and again
xtrue(1,1)=path(1,1);	% initial x
xtrue(2,1)=path(2,1);	% initial y
xtrue(3,1)=atan2(path(2,2)-path(2,1),path(1,2)-path(1,1)); % initial phi
xtrue(4)=0;					% time=0;
utrue(1)=VVEL;				% velocity set at 2 m/s
utrue(2)=0;					% initial steer is zero
utrue(3)=0;					% time=0

% loop control
buf=sprintf('Beginning Simulation, please wait\n');
disp(buf)

index = 1;
for i=1:(tsize-1)
   % find error
   [perr,oerr,index,d]=get_err(xtrue(:,i),path,index);
   
   % compute next state
   [xtrue(:,i+1),utrue(:,i+1)]=get_control(xtrue(:,i),utrue(:,i),perr,oerr,DT);
   if d >10  % test for end of path
      break;
   end
end

% shorten vectors to end length
xtrue=xtrue(:,1:i);
utrue=utrue(:,1:i);
utrue(1,:)=utrue(1,:)/WHEEL_RADIUS; % make speed into rads/s

% add noise if required 
uz(1,:)=utrue(1,:)+GSIGMA_WHEEL*randn(size(utrue(1,:)));
uz(2,:)=utrue(2,:)+GSIGMA_STEER*randn(size(utrue(2,:)));

buf=sprintf('simulation terminating at time %f\n',i*DT);
disp(buf);
figure(PLAN_FIG)
hold on
plot(xtrue(1,:),xtrue(2,:),'g')
hold off


