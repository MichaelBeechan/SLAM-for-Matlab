%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% File   :  relocation.m
%
% solve the vehicle relocation problem
%-------------------------------------------------------
clear all;
addpath('./tools');

% Stochastic map without vehicle, with the following structure:
%
% features:
%               n: 145
%               x: [290x1 double]
%               P: [290x290 double]
%          radius: [145x1 double]
%      var_radius: [145x1 double]
%    covisibility: [145x145 double]
%
load 'data/features';  

% Vehicle data, with the following structure:
%
% vehicle:
%
%      ground: [1x2000 struct]
%    odometry: [1x2000 struct]
%      motion: [1x1999 struct]
%
% vehicle.ground(1):
%
%    x: [3x1 double]
%    P: [3x3 double]
%
global vehicle;
load 'data/vehicle';

% SICK scans: [2000x361 double]
%
load 'data/sick';

% values for the chi squared distrib. at alpha = 0.05
%
% chi2(n) = chi squared function value for n d.o.f.
% chi2 = chi2inv(0.95,1:100)
%
global chi2;              
load 'data/chi2';         

% vehicle position to process
step = 200

% ground truth solution for the vehicle
ground = vehicle.ground(step);

% determines display modes
global configuration;        
configuration.draw_ellipses = 1;
configuration.draw_trunks = 1;
configuration.draw_intermediate_hypotheses = 1;

% WARNING:
% try FIRST your solution with a small map, you'll have to wait less time!
%
configuration.small_map = 1;

if configuration.small_map
    
    few = 1:50;
    few_points = point_rows (few);
    features.x = features.x(few_points);
    features.P = features.P(few_points, few_points);
    
    features.radius = features.radius(few);
    features.var_radius = features.var_radius(few);
    features.covisibility = features.covisibility(few, few);
    features.n = length(few);
    
end

% obtain observations
scan = sick(step,:);
observations = find_trees (scan);

figure(1); clf;
draw_vehicle (ground, 'b');
draw_features (features, 'b');

figure(2); clf;
draw_scan (scan, observations);

disp('Press return to start...');
pause

% execute Geometric Compatibility Branch and Bound
time = cputime;
Hypothesis = relocation_GCBB (features, observations);
time = cputime - time

% estimate vehicle location according to hypothesis
[solution, ok] = estimate_vehicle_location(Hypothesis, features, observations);

error_distance = tdist (solution.x, ground.x)
error_angle = abs(normalize(solution.x(3) - ground.x(3)))

% draw solution
figure(1);
draw_hypothesis (Hypothesis, features, observations, solution, 'r');
