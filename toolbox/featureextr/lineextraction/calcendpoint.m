%CALCENDPOINT Calculate segment endpoints.
%   PE = CALCENDPOINT(P,X) returns the Cartesian coordinates of
%   the segment endpoint PE = [x; y] by perpendicularly project-
%   ing point P = [x; y] onto the alpha,r-line with parameters
%   X = [alpha; r].
%
%   See also EXTRACTLINES.

% v.1.0, 08.01.99, Kai Arras, ASL-EPFL

function pe = calcendpoint(p,x);

cosa = cos(x(1));
sina = sin(x(1));
dist  = x(2) - p(1)*cosa - p(2)*sina;
pe(1) = p(1) + dist*cosa;
pe(2) = p(2) + dist*sina;
