%MAHALANOBISAR Mahalanobis distance of two alpha,r lines.
%   D = MAHALANOBISAR(L1,L2) returns the mahalanobis distance of the
%   two lines L1 and L2 unwrapping the alpha dimension if necessary.
%   L1 and L2 are arrays with elements [alpha r saa srr sar].
%
%   See also MAHALANOBIS, EXTRACTLINES.

% v.1.0, 12.08.97, Kai Arras, ASL-EPFL.

function d = mahalanobisar(l1,l2);

% Step 1: Take difference in angle

% Normalize angle a1.
a1 = l1(1); a2 = l2(1);
% The only reason why the m-file DIFFANGLEUNWRAP is not
% called here is that nested function calls prevent Mat-
% lab from accelerating the code. Refer to the documen-
% tation of the Matlab Profiler.
if a1 >= 2*pi,
  a1 = a1 - 2*pi;
  while a1 >= 2*pi, a1 = a1 - 2*pi; end;
elseif a1 < 0,
  a1 = a1 + 2*pi;
  while a1 < 0, a1 = a1 + 2*pi; end;
end;
% Normalize angle a2
if a2 >= 2*pi,
  a2 = a2 - 2*pi;
  while a2 >= 2*pi, a2 = a2 - 2*pi; end;
elseif a2 < 0,
  a2 = a2 + 2*pi;
  while a2 < 0, a2 = a2 + 2*pi; end;
end;
% Take difference and unwrap
dalpha = a1 - a2;
if a1 > a2,
  while dalpha >  pi, dalpha = dalpha - 2*pi; end;
elseif a2 > a1,
  while dalpha < -pi, dalpha = dalpha + 2*pi; end;
end;

% Step 2: Take difference in r
dr = l1(2)-l2(2);

% Step 3: Put together innovation and innovation covariance
v = [dalpha; dr];
dinv = (l1(3)+l2(3))*(l1(4)+l2(4)) - (l1(5)+l2(5))*(l1(5)+l2(5));
Sinv = [l1(4)+l2(4) -l1(5)-l2(5); -l1(5)-l2(5) l1(3)+l2(3)]/dinv;

% Step 4: Calculate (general) Mahalanobis distance
d = v'*Sinv*v;