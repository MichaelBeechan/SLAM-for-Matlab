function data = generateScript(initialstatemean, numSteps, alphas, betas)

%--------------------------------------------------------------
% Initializations
%--------------------------------------------------------------

global FIELDINFO;
FIELDINFO = getfieldinfo; % retreive information about the soccer field

observationDim = 3; % observation size (dist, bearing, marker ID)
motionDim = 2;

trueRobot = initialstatemean;
rawRobot = initialstatemean;

for t = 1:numSteps
 % --------------------------------------------
  % Simulate motion
  % --------------------------------------------
  
  trueMotion = generateMotion(t);
  
  % Shift true robot
  prevTrueRobot = trueRobot;
  trueRobot = prediction( trueRobot, trueMotion);

  % Move raw robot
  rawRobot = sampleOdometry([prevTrueRobot trueRobot], rawRobot, alphas);
  
  %--------------------------------------------------------------
  % Simulate observation
  %--------------------------------------------------------------

  % t / 2 causes each landmark to be viewed twice
  markerId = mod( floor( t / 2), FIELDINFO.NUM_MARKERS) + 1;
  
  trueObservation = observation( trueRobot, FIELDINFO, markerId);

  % Observation noise
    Q = [ (betas(1) + betas(2) * trueObservation(1))^2  0              0;
	0                                               betas(3)^2     0;
	0                                               0              0];

  observationNoise = sample( Q, observationDim);
  z = trueObservation + observationNoise;
  
  data(t,:) = [trueObservation(1) trueObservation(2) trueObservation(3) ...
	       z(1) z(2) z(3) ...
	       trueRobot(1) trueRobot(2) trueRobot(3) ...
	       rawRobot(1) rawRobot(2) rawRobot(3)];
end
