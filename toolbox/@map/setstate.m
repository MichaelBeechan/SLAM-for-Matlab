%SETSTATE Set map state vector and state covariance matrix.
%   M = SETSTATE(M,X,C) overwrites the map state vector and the state
%   covariance matrix by X and C respectively. The size of X is nx1, 
%   the size of C is nxn where n equals the number of features in M
%   times their number of parameters plus three from the robot.
%
%   See also MAP/GETSTATE, MAP/SET.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH

function m = setstate(m,X,C);

nF = length(m.X);
  
% recast C into blockwise structure
iacc = 1;
for i = 1:nF,
  jacc = 1;
  for j = 1:nF,
    [nr,nc] = size(m.C(i,j).C);
    m.C(i,j).C = C(iacc:iacc+nr-1,jacc:jacc+nc-1);
    jacc = jacc + nc;
  end;
  iacc = iacc + nr;
end;

% recast x into blockwise structure and establish consistency between C and features
iacc = 1;
for i = 1:nF,
  nr = length(get(m.X{i},'x'));
  m.X{i} = set(m.X{i},'x',X(iacc:iacc+nr-1),'c',m.C(i,i).C);
  iacc = iacc + nr;
end;