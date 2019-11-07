function a=a_sub(a1,a2)
%
% A=A_SUB(A1,A2)
% Subtract two angles so that the result 
% always remains between +/- pi
%

% simple function to get angle subtraction consistent


a=a1-a2;

% get to within 2pi of the right answer
a=a - (2.0*pi*fix(a/(2.0*pi)));

% then leave a between +/- pi
while a>pi
  a=a-(2.0*pi);
end

while a< -pi
  a=a+(2.0*pi);
end

