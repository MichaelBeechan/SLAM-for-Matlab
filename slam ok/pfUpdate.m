function [state, weight, mu, sigma, pOfZ, ...
	  predState, predMu, predSigma, zHat] = pfUpdate( state, weight, numSamples, ...
						  u, deltaT, M, ...
						  z, Q, ...
						  markerId, FIELDINFO)

% NOTE: The header is not set in stone.  You may change it if you like

global stateDim;
global motionDim;
global observationDim;

% ----------------------------------------------------------------
% ----------------------------------------------------------------
% Prediction step
% ----------------------------------------------------------------
% ----------------------------------------------------------------

% some stuff goes here

% Compute mean and variance of estimate. Not really needed for inference.
[ predMu predSigma] = meanAndVariance( state, numSamples);

% ----------------------------------------------------------------
% ----------------------------------------------------------------
% Correction step
% ----------------------------------------------------------------
% ----------------------------------------------------------------

% more stuff goes here
  
disp('PF update');

pOfZ = 1.0;
