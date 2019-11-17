%CALCINNOVATION Calculate innovation between two alpha,r-line features.
%   NU = CALCINNOVATION(L1,L2) returns the difference of the state vectors
%   of alpha,r-line features L1 and L2.
%
%   Note that for features with angles this is the place to unwrap angle
%   differences.
%
%   See also ARLINEFEATURE.

% v.1.0, Dec. 2003, Kai Arras, CAS-KTH

function nu = calcinnovation(l1,l2);

% Take difference, unwrapping alpha.
nu(1,1) = diffangleunwrap(l1.x(1),l2.x(1));
nu(2,1) = l1.x(2) - l2.x(2);