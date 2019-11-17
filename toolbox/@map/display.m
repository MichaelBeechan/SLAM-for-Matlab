%DISPLAY Display method for map object.
%   DISPLAY(M) displays the map object M.
%
% See also MAP.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function display(m);

disp(['Map "', m.name,'":']);
disp(sprintf(' time = %d', m.timestamp));

% display robot information first, assuming
% a single robot per map
nF = length(m.X);
i = 1;
found = 0;
while (i <= nF) & ~found,
  if isa(m.X{i},'robotdd'),
    found = 1;
    irobot = i;
  end;
  i = i + 1;
end;
if found,
  disp('Robot:');
  display(m.X{irobot});
else
  disp('No robot');
end;

% display feature information
if ((~found & (nF > 0)) | (found & (nF > 1))),
  disp('Features:');
  for i = 1:nF,
    if ~found | (i ~= irobot),
      display(m.X{i});
    end;
  end;
else
  disp('No features');
end;