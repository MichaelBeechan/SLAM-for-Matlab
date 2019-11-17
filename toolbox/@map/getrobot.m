%GETROBOT Get robot from map.
%   R = GETROBOT(M) returns the robot object in map M. If M
%   contains no robot, R is empty.
%
%   Example:
%      r = getrobot(G);
%
%   See also MAP/GET, MAP/GETSTATE.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Jan. 2004, Kai Arras: returns all robots in M using cat

function r = getrobot(M);

if (isa(M,'map')),
  
  X = M.X;
  i = 1; found = 0;
  while (i <= length(X)) & ~found,
    if isa(X{i},'robot'),
      found = 1;
      r = X{i};
    else
      i = i + 1;
    end;
  end;
  
else
  error('map/getrobot: Input argument is not a map object')
end;