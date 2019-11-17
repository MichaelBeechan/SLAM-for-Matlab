%PREDICTMEASUREMENTS Transforms map features into the local frame.
%   [GPRED,HPRED] = PREDICTMEASUREMENTS(G) applies the observation 
%   function to all features in the map by transforming them from
%   the global coordinate frame into the local frame given the
%   current robot pose. Returns the predicted measurements in the
%   map GPRED and the structure HPRED with the individual measure-
%   ment Jacobians:
%      HPRED(i).HR: measurement Jacobian of the i-th feature with
%                   respect to the robot
%      HPRED(i).HM: measurement Jacobian of the i-th feature with
%                   respect to the map feature
%
%   The function iterates over the map features in G and calls
%   the PREDICT method of the feature objects.
%
%   See also POINTFEATURE/PREDICT, ARLINEFEATURE/PREDICT.

% v.1.0, Kai Arras, Nov. 2003, CAS-KTH

function [Gpred,Hpred] = predictmeasurements(Gin);

% Get data from Gin
X  = get(Gin,'x');  C  = get(Gin,'c');
n  = length(X);
% Get robot and its pose
r  = getrobot(Gin);
xr = get(r,'x'); Cr = get(r,'C');

if n > 1,
  
  % init new map
  Gpred = map('measurement prediction map',0);

  % traverse Gin, fill in Gpred and Hpred
  for i = 2:n,
    Crp = C(1,i).C;
    [pr,Hr,Hm] = predict(X{i},xr,Cr,Crp);
    % store measurement Jacobians at index i-1
    Hpred(i-1).Hr = Hr;
    Hpred(i-1).Hm = Hm;
    % add to map: makes it consistent with C
    % and fills in zeros in the off-diagonal
    Gpred = addentity(Gpred, pr);
  end;
  
else
  Gpred = []; Hpred = [];
end;