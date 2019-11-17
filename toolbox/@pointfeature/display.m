%DISPLAY Display method for point feature object.
%   DISPLAY(P) displays the point feature P.
%
% See also POINTFEATURE.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function display(p);

display(p.entity);
xs = num2str(p.x);
Cs = num2str(p.C);
disp(sprintf('  x = %s       C = %s', xs(1,:), Cs(1,:)));
disp(sprintf('      %s           %s', xs(2,:), Cs(2,:)));