% Experiment set up file for the Matlab Robot Navigation Toolbox 
% Date: 07.12.03
% Author: Kai Arras, CAS-KTH
% Description: The 'sjursflat'-data set shows the ground floor of Sjur
% Vestli's house, recorded using a SmartRob 2 with a forward looking
% SICK LMS200. The data set contains range and beacon/retro-reflector
% information. Opposed to the setup file 'sjursflatsetupbeacons.m', in
% this experiment we do line-based SLAM and therefore read only the
% range information from 'sjursflat.scn'.


% ----- Sensor 1 Model and File Settings ----- %
% sensor name
params.sensor1.name = 'Wheel encoders';
% full file name and label to look for
params.sensor1.datafile = 'sjursflat.enc';
params.sensor1.label = 'E';
% is information in file relative 0: no, 1: yes
params.sensor1.isrelative = 1;
% index string
params.sensor1.indexstr = '1,2,4,3';
% robot odometry error model
params.sensor1.kl = 0.00005;     % error growth factor for left wheel in [1/m]
params.sensor1.kr = 0.00005;     % error growth factor for right wheel in [1/m]


% ----- Sensor 2 Model and File Settings ----- %
% sensor name
params.sensor2.name = 'Sick LMS200 indoor';
% full file name and label to look for
params.sensor2.datafile = 'sjursflat.scn';
params.sensor2.label = 'S';
% index string
params.sensor2.indexstr = '1,2,3,4:2:end,5:2:end';
% feature extraction m-file
params.sensor2.extractionfnc = 'extractlines';
% maximal perception radius of sensor in [m]
params.sensor2.rs = 8.0;
% angular resolution in [rad]
params.sensor2.anglereso = 0.5*pi/180;
% constant range uncertainty in [m]
params.sensor2.stdrho = 0.03;
% robot-to-sensor transform expressed in the
% robot frame with units [m] [m] [rad]
params.sensor2.xs = [0.2945; 0; 0.0];


% ----- Master Sensor Setting ----- %
% define master sensor
params.mastersensid = 2;


% ----- Robot Model ----- %
% robot name
params.robot.name = 'SmartRob2';
% robot class name
params.robot.class = 'robotdd';
% robot form type (see help drawrobot)
params.robot.formtype = 4;
% robot kinematics
params.robot.b  = 0.396;     % robot wheelbase in [m]
params.robot.rl = 0.038;     % left wheel radius in [m]
params.robot.rr = 0.038;     % right wheel radius in [m]
% initial robot start pose and pose covariance
params.robot.x = zeros(3,1);
params.robot.C = 0.0001*eye(3);


% ----- Map File for Localization ----- %
% define a priori map file, '' for slam experiments
params.mapfile = '';


% ----- Feature Extraction ----- %
% size of sliding window
params.windowsize = 11;       % in number of points
% threshold on compactness
params.threshfidel = 0.1;
% significance level for line fusion
params.fusealpha = 0.9999;    % between 0 and 1
% minimal length a segment must have to be accepted
params.minlength = 0.6;       % in [m]
% heuristic compensation factors for raw data correlatins
params.compensa = 1*pi/180;   % in [rad]
params.compensr = 0.01;       % in [m]
% are the scans cyclic?
params.cyclic = 0;            % 0: non-cyclic or 1: cyclic


% ----- Data Association ----- %
% significance level for NNSF matching
params.alpha = 0.99;


% ----- Slam ----- %
% optional axis vector for global map figure. Useful with infinite lines
params.axisvec = [-3 7 -8 1.2];