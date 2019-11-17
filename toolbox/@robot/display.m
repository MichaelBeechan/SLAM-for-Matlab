%DISPLAY Display method for robot object.
%   DISPLAY(R) displays the robot object R.
%
% See also ROBOT.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Nov. 2003, Kai Arras

function display(r);

display(r.entity);
disp(sprintf('  name = %s', r.name));
disp(sprintf('  time = %d', r.t));
disp(sprintf('  form type = %d', r.formtype));