%-------------------------------------------------------
% simulate motion
%-------------------------------------------------------
function m = generateMotion( t)

t = mod(t-1, 5);

if t == 0
  m = [100; 0];
elseif t == 1
  m = [100; 0];
elseif t == 2
  m = [100; deg2rad(90)];
elseif t == 3
  m = [100; 0];
elseif t == 4
  m = [0; deg2rad(90)];
end
  
