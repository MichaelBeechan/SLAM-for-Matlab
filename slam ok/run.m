function run(numSteps)

%--------------------------------------------------------------
% Graphics
%--------------------------------------------------------------

TRUE_ROB_COL = [ 1 1 1 ];
TRUE_PATH_COL = [ 0 0 1 ];
RAW_PATH_COL = [ 0 1 0 ];

GLOBAL_FIGURE = 1;

%--------------------------------------------------------------
% Initializations
%--------------------------------------------------------------

initialstatemean = [80 50 0 ]';

% Motion noise (in odometry space)
alphas = [0.001 0.0001 0.001 0.001];

% Sensor noise (see generateScript.m to see what the betas correspond to)
betas = [10 0.15 deg2rad(5)];

data = generateScript(initialstatemean, numSteps, alphas, betas)

% call ekfUpdate and pfUpdate here
% you might consider putting in a switch so you can select which
% algorithm does the update
for t = 1:numSteps
  % since we don't care about the data association problem, trueObs(3)
  % and rawObs(3) will always be the same
  trueObs = data(t,1:3);
  rawObs = data(t,4:6);

  % true position
  x = data(t,7);
  y = data(t,8);
  theta = data(t,9);
  
  figure(GLOBAL_FIGURE); clf; hold on; plotfield(trueObs(3));
  plotrobot( x, y, theta, 'black', 1, TRUE_ROB_COL);
  
  % draw initial part of path
  plot([initialstatemean(1) data(1,7)], [initialstatemean(2) data(1,8)], 'Color', TRUE_PATH_COL);
  plot([initialstatemean(1) data(1,10)], [initialstatemean(2) data(1,11)], 'Color', RAW_PATH_COL);

  % draw true path
  plot(data(1:t,7), data(1:t,8), 'Color', TRUE_PATH_COL);
  % draw noisy path
  plot(data(1:t,10), data(1:t,11), 'Color', RAW_PATH_COL);

  % draw observation from true position
  obsLoc = endPoint([x y theta], trueObs); % what happens if you replace trueObs with rawObs?
  plot([x obsLoc(1)], [y obsLoc(2)], 'Color', 'red');
  
  pause(0.3);
end
