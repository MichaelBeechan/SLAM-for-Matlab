% A script file to look in detail at one step in the
% filter calculation. Requires complete filter to have been
% run previously

dt=utrue(3,tstep)-utrue(3,tstep-1);
time=utrue(3,i);
[xp1 Pp1]=pred(xest(:,tstep-1),squeeze(Pest(:,:,tstep-1)),dt,utrue(:,tstep));
[xe1 Pe1 in1 ins1]=update(xp1,Pp1,obs(:,tstep),beacons);
