%GETSTATE Get map state vector and state covariance matrix.
%   [X,C] = GETSTATE(M) returns the stacked map state vector X and
%   the stacked state covariance matrix C of map M. The size of X 
%   is nx1, the size of C is nxn where n equals the number of 
%   features in M times their number of parameters plus three from
%   the robot.
%
%   See also MAP/SETSTATE, MAP/GET.

% v.1.0, Nov. 2003, Kai Arras, CAS-KTH


function [X,C] = getstate(m);

nF = length(m.X);

% --- Cast blockwise structure into vector X
X = [];
for i = 1:nF;
  X = [X;get(m.X{i},'x')];
end;

% --- Cast blockwise structure into matrix C
C = [];
for i = 1:nF,
  C = cat(2,C,cat(1,m.C(:,i).C));   % cat(1,m.C(:,i).C) is block colon i
end;