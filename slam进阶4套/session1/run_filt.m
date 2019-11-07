globals;
ginit;

disp('Press return to run filter');
pause;

%initial_errors=[5; 5; 0.2; 0.1]
% initialise filter
xinit=xtrue(:,1);
xinit(4,1)=WHEEL_RADIUS;
%xinit=xinit+initial_errors;

Pinit= [0.024 0.0   0.0     0.0;
        0.0   0.024 0.0     0.0;
        0.0   0.0   0.00025 0.0;
        0.0   0.0   0.0     0.0001];
     
%run filter     
[xest,Pest,xpred,Ppred,innov,innvar]=kfilter(obs,utrue,xinit,Pinit,beacons);

disp('Completed Filtering')
     
        