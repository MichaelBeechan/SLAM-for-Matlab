% Experiment set up file for the Matlab Robot Navigation Toolbox 
% Date: 07.12.03
% Author: Kai Arras, CAS-KTH
% Description: The 'sjursflat'-data set shows the ground floor of Sjur
% Vestli's house, recorded using a SmartRob 2 with a forward looking
% SICK LMS200. The data set contains range and beacon/retro-reflector
% information. The files 'sjursflat.bcn' and 'sjursflat.scn' are iden-
% tical and have been duplicated and renamed since they contain both,
% the range and the beacons information. By looking for the respective
% labels (i.e. 'B' and 'S') the information can be properly extracted.
% When calling this setup file, beacon-based slam is done.


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
% non-systematic odometry error model
params.sensor1.kl = 0.00001;     % error growth factor for left wheel in [1/m]
params.sensor1.kr = 0.00001;     % error growth factor for right wheel in [1/m]


% ----- Sensor 2 Model and File Settings ----- %
% sensor name
params.sensor2.name = 'Sick LMS200 indoor';
% full file name and label to look for
params.sensor2.datafile = 'sjursflat.scn';
params.sensor2.label = 'S';
% temporal and spatial downsampling factor
params.sensor2.tdownsample = 1;
params.sensor2.sdownsample = 20;
% index string
params.sensor2.indexstr = '1,2,3,4:2:end,5:2:end';
% maximal perception radius of sensor in [m]
params.sensor2.rs = 8.0;
% angular resolution in [rad]
params.sensor2.anglereso = 0.5*pi/180;
% constant range uncertainty in [m]
params.sensor2.stdrho = 0.02;
% robot-to-sensor transform expressed in the
% robot frame with units [m] [m] [rad]
params.sensor2.xs = [0.2945; 0; 0.0];


% ----- Sensor 3 Model and File Settings ----- %
% sensor name
params.sensor3.name = 'SICK LMS200 Beacons';
% full file name and label to look for
params.sensor3.datafile = 'sjursflat.bcn';
params.sensor3.label = 'B';
% index string
params.sensor3.indexstr = '1,2,3,4:2:end,5:2:end';
% feature extraction m-file
params.sensor3.extractionfnc = 'extractbeacons';
% robot-to-sensor transform expressed in the
% robot frame with units [m] [m] [rad]
params.sensor3.xs = [0.2945; 0; 0.0];


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
params.robot.b  = 0.396;      % robot wheelbase in [m]
params.robot.rl = 0.038;      % left wheel radius in [m]
params.robot.rr = 0.038;      % right wheel radius in [m]
% initial robot start pose and pose covariance
params.robot.x = zeros(3,1);
params.robot.C = 0.0001*eye(3);


% ----- Map File for Localization ----- %
% define a priori map file, '' for slam experiments
params.mapfile = '';


% ----- Feature Extraction ----- %
% jump distance for beacon segmentation
params.beaconthreshdist = 0.15;   % in [m]
% beacons which are farer away than rs-ignoredist are ignored
params.ignoredist = 0.1;          % in [m]
% minimal nof raw points on reflector in order to be valid
params.minnpoints = 2;
% constant beacon covariance matrix
params.Cb = 0.01*eye(2);


% ----- Data Association ----- %
% significance level for NNSF matching
params.alpha = 0.999;