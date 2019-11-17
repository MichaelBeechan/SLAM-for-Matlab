%CALCINNOVATION Calculate innovation between two point features.
%   NU = CALCINNOVATION(P1,P2) returns the difference of the state vectors
%   of point features P1 and P2. Note that for features with angles this
%   is the place to unwrap angle differences.
%
%   See also POINTFEATURE.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH


function nu = calcinnovation(p1,p2);

% Take difference. Trivial for point features as there are no angles
nu = p1.x - p2.x;