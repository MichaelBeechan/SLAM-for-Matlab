%MEANWM Multivariate weighted mean (Information Filter).
%   [XW,CW] = MEANWM(X,C) calculates the multivariate weighted mean
%   equivalent to the information filter (IF). X is a matrix of di-
%   mension m x n where each column is interpreted as a random vector
%   of dimension m x 1. C is a m x m x n matrix where each m x m
%   matrix is interpreted as the covariance estimate associated to
%   its respective row vector. The function returns the weighted mean
%   vector XW and the weighted covariance matrix CW of dimensions
%   m x 1 and m x m respectively.
%
%   See also MEAN.

% v.1.0, 14.08.97, Kai Arras, ASL-EPFL
% v.1.1, Dec.2003, Kai Arras, CAS-KTH

function [xwm,Cwm] = meanwm(xv,Cv)

% Get size and initialize accumulators
m = size(xv,1);
n = size(xv,2);
Caccu = zeros(m);
xaccu = zeros(m,1);

% Add together
for i = 1:n;
  Ci = Cv(:,:,i);
  xi = xv(:,i);
  invCi = inv(Ci);
  Caccu = Caccu + invCi;
  xaccu = xaccu + invCi*xi;
end;

% Return
Cwm = inv(Caccu);     % weighted covariance matrix
xwm = Cwm*xaccu;      % weighted mean