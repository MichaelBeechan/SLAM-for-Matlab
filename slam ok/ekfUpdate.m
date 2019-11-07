function [mu, sigma, pOfZ, ...
	  predMu, predSigma, zHat, G, R, H, K ] = ekfUpdate( mu, sigma, ...
						  u, deltaT, M, ...
						  z, Q, ...
						  markerId, FIELDINFO)

% NOTE: The header is not set in stone.  You may change it if you like.


global stateDim;
global observationDim;
global motionDim;

% --------------------------------------------
% Prediction step
% --------------------------------------------

% some stuff here

% Kalman prediction of mean and covariance

%--------------------------------------------------------------
% Correction step
%--------------------------------------------------------------

% Compute expected observation and Jacobian

% Innovation / residual covariance

% Residual

% Likelihood

% Kalman gain

% Correction
