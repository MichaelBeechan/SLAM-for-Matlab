%MOD2   Matlab index-compatible modulus after division.
%   Y = MOD2(X,LEN) returns X modulus LEN such that Y is always
%   within the valid index range of MATLAB arrays.
%
%   Example:
%      len = 4,   x: ... -2 -1  0  1  2  3  4  5  6 ...
%                 y: ...  2  3  4  1  2  3  4  1  2 ...
%
%   See also MOD, REM.

% v.1.0, 11.01.99, Kai Arras, ASL-EPFL

function y = mod2(x,l);

y = mod(x-1,l) + 1;