function beacons=get_beacons
%
%  beacons=get_beacons
%
% HDW 28/04/00
% function to graphically input beacon locations
% beacons is 2*N matrix containing x,y locations of beacons


% set up the figure

globals;
figure(PLAN_FIG)
clf
v=[0 WORLD_SIZE 0 WORLD_SIZE];
axis(v);
hold on;
bin=1;
nbeacons=0;
beacons=zeros(1,2);

% now get beacons graphically until return 
while bin
   [x,y]=ginput(1);
   bin= ~isempty(x);
   if bin
      nbeacons=nbeacons+1;
      plot(x,y,'go')
      beacons(nbeacons,1)=x;
      beacons(nbeacons,2)=y;
   end
end
hold off
