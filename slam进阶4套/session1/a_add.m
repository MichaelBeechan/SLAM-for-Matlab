function a=a_add(a1,a2)
%
% A=A_ADD(A1,A2)
% Add two angles so that the result 
% always remains between +/- pi
%

a=a1+a2;

% get to within 2pi of the right answer
a=a - (2.0*pi*fix(a/(2.0*pi)));

% then leave a between +/- pi
while a>pi
  a=a-(2.0*pi);
end

while a< -pi
  a=a+(2.0*pi);
end

