%-------------------------------------------------------
% shift state
%-------------------------------------------------------
function pred = prediction( state, motion)

theta = state(3);

if ( motion(2) == 0.0)
  shiftMu = [ motion(1) * cos( theta);
	      motion(1) * sin( theta);
	      0];
  
else
  radius = motion(1) / motion(2);
  shiftMu = [ - radius * sin( theta) + radius * sin( theta + motion(2));
	      radius * cos( theta) - radius * cos( theta + motion(2));
	      motion(2)];
end

pred = state + shiftMu;
pred(3) = minimizedAngle( pred(3));
