%SETROBOT Set robot from map.
%   M = SETROBOT(M,R) sets the robot object in map M if M already
%   contains a robot. Otherwise M will be unchanged. Use ADDENTITY
%   to add a robot to a map.
%
%   Note that the assignment to the output M is necessary since
%   Matlab does not support passing arguments by reference.
%   Hence the set method actually operates on a copy of the object.
%
%   See also MAP/GETROBOT, MAP/GET.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Jan. 2004, Kai Arras

function M = setrobot(M,r);

if isa(M,'map') & isa(r,'robot'),
  
  % search robot (one robot per map assumed)
  found = 0; i = 1;
  while (i <= length(M.X)) & ~found,
    if isa(M.X{i},'robot'),
      found = 1;
    else
      i = i + 1;
    end;
  end;
  
  % set robot pose and pose covariance
  M.X{i} = set(M.X{i},'x',get(r,'x'));
  M.X{i} = set(M.X{i},'c',get(r,'c'));
  
  % make consistent, update C structure
  M.C(i,i).C = get(r,'c');
  
else
  error('map/setrobot: Wrong input. Check your arguments')
end;