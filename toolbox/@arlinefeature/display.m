%DISPLAY Display method for alpha,r-line feature object.
%   DISPLAY(L) displays the alpha,r-line feature L.
%
% See also ARLINEFEATURE.

% v.1.0, Dec. 2003, Kai Arras, CAS-KTH

function display(l);

display(l.entity);
xs = num2str(l.x);
Cs = num2str(l.C);
disp(sprintf('  alpha = %s       C = %s', xs(1,:), Cs(1,:)));
disp(sprintf('      r = %s           %s', xs(2,:), Cs(2,:)));