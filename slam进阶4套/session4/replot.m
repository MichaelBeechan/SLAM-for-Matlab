figure(13)
clf
v=[0 WORLD_SIZE 0 WORLD_SIZE];
axis(v);
hold on;
plot(xtrue(1,:),xtrue(2,:),'r',beacons(:,1),beacons(:,2),'go')
legend('True Trajectory','Beacon Locations')
title('Vehicle Trajectory and Beacon Locations')
xlabel('X distance (m)')
ylabel('Y distance (m)')
hold off
