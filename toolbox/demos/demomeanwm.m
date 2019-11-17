% demomeanwm shows meanwm.m in action

x1 = [-1; 0];
C1 = [0.001 0.0005; 0.0005 0.002];
x2 = [-1; 0.5];
C2 = [0.002 -0.001; -0.001 0.003];
x3 = [1; -1];
C3 = [0.003 0.00005; 0.00005 0.0001];
x4 = [0.8; -1.3];
C4 = [0.0015 -0.0001; -0.0001 0.005];
x5 = [1.1; -0.8];
C5 = [0.005 0.0005; 0.0005 0.0001];
x6 = [0.5; 0.2];
C6 = [0.003 -0.001; -0.001 0.005];
x7 = [0.55; 0.15];
C7 = [0.005 0.0002; 0.0002 0.001];

figure(1); clf; hold on; axis equal; set(gca,'Box','on');

plot(x1(1),x1(2),'k+');
drawprobellipse(x1,C1,0.95,'b');
plot(x2(1),x2(2),'k+');
drawprobellipse(x2,C2,0.95,'b');
plot(x3(1),x3(2),'k+');
drawprobellipse(x3,C3,0.95,'b');
plot(x4(1),x4(2),'k+');
drawprobellipse(x4,C4,0.95,'b');
plot(x5(1),x5(2),'k+');
drawprobellipse(x5,C5,0.95,'b');
plot(x6(1),x6(2),'k+');
drawprobellipse(x6,C6,0.95,'b');
plot(x7(1),x7(2),'k+');
drawprobellipse(x7,C7,0.95,'b');

x = cat(2,x1,x2);
C = cat(3,C1,C2);
[xw,Cw] = meanwm(x,C);
plot(xw(1),xw(2),'r+');
drawprobellipse(xw,Cw,0.95,'r');

x = cat(2,x3,x4,x5);
C = cat(3,C3,C4,C5);
[xw,Cw] = meanwm(x,C);
plot(xw(1),xw(2),'r+');
drawprobellipse(xw,Cw,0.95,'r');

x = cat(2,x6,x7);
C = cat(3,C6,C7);
[xw,Cw] = meanwm(x,C);
plot(xw(1),xw(2),'r+');
drawprobellipse(xw,Cw,0.95,'r');
