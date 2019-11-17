%GRAPHICSDEMO Demo script for the graphic functions of this directory.

% v.1.0, 04.12.03, Kai Arras, CAS-KTH

clc;
disp('>> Press a key to start demo draw functions');
pause;

figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Arrows');

x0 = [0 0 0];
x1 = [-3 2 -pi/8];
x2 = [-2 1 3*pi/2];
x3 = [-1 -2 pi/3];
x4 = [0 -1 -9*pi/10];
x5 = [1 3 -pi/1.8]; 
x6 = [2 0 pi/30];
x7 = [-1 2 0];
x8 = [-2 -1 5*pi/6];

drawarrow(x1,x2,0,.3,'b');
drawarrow(x3,x4,1,.5,'r');
drawarrow(x0,x5,1,1,[.4 .9 .1]);
drawarrow(x5,x6,0,1,'k');
drawarrow(x7,x8,1,0.2,[.6 .6 .2]);

pause;
figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Gaussians probability regions');

C1 = [0.1 -0.08; -0.08 0.13];
C2 = [0.2 0.1; -0.1 0.13];
C3 = [0.05 0; 0 0.05];
drawprobellipse(x1,C1,0.9,[.5 .5 0]);
drawprobellipse(x1,C1,0.95,[.7 .5 0]);
drawprobellipse(x1,C1,0.99,[.9 .5 0]);
drawprobellipse(x6,C2,0.9,'b');
drawprobellipse(x3,C3,0.9,'g');

pause;
figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Rounded Rectangles');

drawroundedrect(x1,1,0.6,0.2,0,'b');
drawroundedrect(x5,1,1.2,0.1,1,[.4 .9 0]);
set(drawroundedrect(x7,.3,.7,.15,0,[.9 .7 0]),'LineWidth',3);
drawroundedrect(x6,.1,1.9,0.0,0,'r');
drawroundedrect(x4,.4,.4,0.2,1,[.4 .4 .4]);

pause;
figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Scalable text');

plot(x1(1),x1(2),'k+');
drawlabel(x1,'12',1,0.2,[.6 .6 .2]);
plot(x3(1),x3(2),'k+');
set(drawlabel(x3,'WER',0.3,0.1,'k'),'LineWidth',2);
plot(x4(1),x4(2),'k+');
drawlabel(x4,'R1',0.2,0.05,[.6 .6 .6]);
plot(x5(1),x5(2),'k+');
drawlabel(x5,'F30493',0.8,0.05,[.4 .9 .1]);
plot(x8(1),x8(2),'k+');
set(drawlabel(x8,'S04',0.3,0.1,'r'),'LineWidth',3);

pause;
figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Transforms');

plot(-3,-2,'k+'); plot(-2, 2,'k+');
drawtransform([-3 -2],[-2 2],'/','x1',[.8 .8 .8]);
plot(-2,-2,'k+'); plot(-1, 2,'k+');
drawtransform([-2 -2],[-1 2],'\','x2',[.6 .6 .6]);
plot(-1,-2,'k+'); plot( 0, 2,'k+');
drawtransform([-1 -2],[ 0 2],'(','x3',[.3 .3 .3]);
plot( 0,-2,'k+'); plot( 1, 2,'k+');
drawtransform([ 0 -2],[ 1 2],')','x4',[.0 .0 .0]);
axis([-3.5 1.5 -2.5 2.5]);

pause;
figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Reference frames');

drawreference(x1,'W',1,'k');
drawreference(x4,'R44',0.3,'b');
drawreference(x5,'R43',0.4,[.8 .5 .1]);
set(drawreference(x6,'98',0.7,[.6 .6 .6]),'LineWidth',2);

pause;
figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Robots');

f = 0.2;
drawrobot(x1,'k',0);
drawrobot(2*f*x1,'k',1);
drawrobot(3*f*x1,'k',2);
drawrobot(4*f*x1,'k',3);
drawrobot(5*f*x1,'k',4);
drawrobot(6*f*x1,'k',5);

clc;
pause;

% Demonstrate drawrobot
figure(1);clf;hold on;zoom on;axis('equal');
set(gca,'Box','On'); title('Toolbox as a drawing tool');

% Constants
FSIZE = 0.6;    % size of reference frames in [m]
LEVEL = 0.95;   % probability level of position ellipses

% draw world frame
drawreference(zeros(3,1),'W',FSIZE,'k');

% draw robot
xwr = [2, 3, -pi/3];
drawprobellipse(xwr,[0.001,0.001;0.001,0.02],LEVEL,[0.7 0 0]);
drawrobot(xwr,'k');
drawreference(xwr,'R',FSIZE,[0.7 0 0]);
drawtransform(zeros(3,1),xwr,'(','x_W_R','k');

% draw model feature
xwm = [4, 2, pi/9];
drawprobellipse(xwm,[0.02,-0.003;-0.003,0.001],LEVEL,[0 0.7 0]);
drawreference(xwm,'M',FSIZE,[0 0.7 0]);
drawtransform(zeros(3,1),xwm,'/','x_W_M','k');

% draw observed feature
xwe = [4.5, 1.2, 3.6*pi/5];
drawprobellipse(xwe,[0.002,-0.001;-0.001,0.001],LEVEL,[0 0 0.7]);
drawreference(xwe,'E',FSIZE,[0 0 0.7]);
drawrobot(xwe,[0 0 0.7]);
drawtransform(xwr,xwe,'\','x_R_E','k');

% draw relative relationship
drawtransform(xwm,xwe,')','x_M_E','k');

xre = compound(icompound(xwr),xwe);
% correct!

compound(xwr,xre);
compound(xre,xwr);
