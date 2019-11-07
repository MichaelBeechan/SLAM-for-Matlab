replot

figure(2)
clf
hold on;
v=[0 WORLD_SIZE 0 WORLD_SIZE];
axis(v);
%plot(beacons(:,1),beacons(:,2),'go')
[obs_p, state_p]=p_obs(obs,xtrue);
plot(xtrue(1,:),xtrue(2,:),'b',obs_p(1,:),obs_p(2,:),'rx')
legend('True Vehicle Path','Beacon Observations')
title('True Vehicle Path and Beacon Observations')
xlabel('X distance (m)')
ylabel('Y distance (m)')
hold off


figure(3)
clf
hold on
plot(xtrue(4,:),abs(xtrue(1,:)-xest(1,:)),'r',xtrue(4,:),sqrt(squeeze(Pest(1,1,:))),'b')
legend('True Error','Estimated Error')
xlabel('Time (s)')
ylabel('Error (m)')
title('X Direction Error')
hold off

figure(4)
clf
hold on
plot(xtrue(4,:),abs(xtrue(2,:)-xest(2,:)),'r',xtrue(4,:),sqrt(squeeze(Pest(2,2,:))),'b')
legend('True Error','Estimated Error')
xlabel('Time (s)')
ylabel('Error (m)')
title('Y Direction Error')
hold off

figure(5)
clf
hold on
plot(xtrue(4,:),abs(xtrue(3,:)-xest(3,:)),'r',xtrue(4,:),sqrt(squeeze(Pest(3,3,:))),'b')
legend('True Error','Estimated Error')
xlabel('Time (s)')
ylabel('Error (rads)')
title('Orientation Error')
hold off

figure(6)
clf
hold on
plot(xtrue(4,:),xest(4,:),'r',xtrue(4,:),WHEEL_RADIUS+sqrt(squeeze(Pest(4,4,:))),'b',xtrue(4,:),WHEEL_RADIUS-sqrt(squeeze(Pest(4,4,:))),'b')
legend('Estimated Wheel Radius','Estimated Wheel Radius Error')
title('Estimated Wheel Radius and Wheel Radius Error')
xlabel('Time (s)')
ylabel('Wheel Radius (m)');
hold off

%[inn,sinn]=proc_innov(innov,innvar,obs);
[inn,sinn]=track_innov(innov,innvar,obs,xest,utrue);

figure(7)
clf
hold on
plot(inn(3,:),inn(1,:),'bx')
plot(inn(3,:),inn(1,:),'b')
plot(inn(3,:),sinn(1,:),'g')
plot(inn(3,:),-sinn(1,:),'g')
title('Long-Track Innovation and Innovation Standard Deviation')
xlabel('Time (s)')
ylabel('Innovation (m)');
hold off

figure(8)
clf
hold on
plot(inn(3,:),inn(2,:),'bx')
plot(inn(3,:),inn(2,:),'b')
plot(inn(3,:),sinn(2,:),'g')
plot(inn(3,:),-sinn(2,:),'g')
title('Cross-Track Innovation and Innovation Standard Deviation')
xlabel('Time (s)')
ylabel('Innovation (m)');
hold off

[rows,cols]=size(xest);

rho=zeros(6,cols);

for i=1:cols
   %x-y
   rho(1,i)=Pest(1,2,i)/sqrt(Pest(1,1,i)*Pest(2,2,i));
   %x-phi
   rho(2,i)=Pest(1,3,i)/sqrt(Pest(1,1,i)*Pest(3,3,i));
   %y-phi
   rho(3,i)=Pest(2,3,i)/sqrt(Pest(2,2,i)*Pest(3,3,i));
   %x-R
   rho(4,i)=Pest(1,4,i)/sqrt(Pest(1,1,i)*Pest(4,4,i));
   %y-R
   rho(5,i)=Pest(2,4,i)/sqrt(Pest(2,2,i)*Pest(4,4,i));
   %Phi-R
   rho(6,i)=Pest(3,4,i)/sqrt(Pest(3,3,i)*Pest(4,4,i));

end


figure(9)
clf
hold on
plot(xtrue(4,:),rho(1,:))
xlabel('Time (s)')
ylabel('Correlation Coefficient')
title('X-Y Correlation Coefficient')
hold off

figure(10)
clf
hold on
plot(xtrue(4,:),rho(2,:),'b',xtrue(4,:),rho(3,:),'r')
legend('X to Orientation Correlation','Y to Orientation Correlation')
xlabel('Time (s)')
ylabel('Correlation Coefficient')
title('Position to Orientation Correlation Coefficient')
hold off

figure(11)
clf
hold on
plot(xtrue(4,:),rho(4,:),'b',xtrue(4,:),rho(5,:),'r')
legend('X to Wheel Radius Correlation','Y to Wheel Radius Correlation')
xlabel('Time (s)')
ylabel('Correlation Coefficient')
title('Position to Wheel Radius Correlation Coefficient')
hold off

figure(12)
clf
hold on
plot(xtrue(4,:),rho(6,:),'b')
xlabel('Time (s)')
ylabel('Correlation Coefficient')
title('Orientation to Wheel Radius Correlation Coefficient')
hold off
