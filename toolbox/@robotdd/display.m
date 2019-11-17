%DISPLAY Display method for differential drive robot object.
%   DISPLAY(R) displays the differential drive robot object R.
%
% See also ROBOTDD.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function display(r);

display(r.robot);
if size(r.x) == [1 3], x = r.x'; else x = r.x; end;
xr = num2str(x);
Cr = num2str(r.C);
disp(sprintf('  x = %s       C = %s', xr(1,:), Cr(1,:)));
disp(sprintf('      %s           %s', xr(2,:), Cr(2,:)));
disp(sprintf('      %s           %s', xr(3,:), Cr(3,:)));
disp(sprintf('  rl = %s', num2str(r.rl)));
disp(sprintf('  rr = %s', num2str(r.rr)));
disp(sprintf('  b  = %s', num2str(r.b)));