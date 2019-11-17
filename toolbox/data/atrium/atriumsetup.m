% Experiment setup file for the CAS Robot Navigation Toolbox 
% Date: 21.12.03
% Author: Kai Arras, CAS-KTH
% Description: The atrium data set has been recorded by Patric Jensfelt
% in the KTH main building, Stockholm. The robot is a Nomad Scout with
% a forward looking SICK LMS200. Scan frequency is quite high, greater
% than the frequency of the encoder measurements. The data set is
% challenging as the environment is highly dynamic.
% In this experiment, the scans are downsampled by a factor of five
% for accelerating purposes.


% ----- Sensor 1 Model and File Settings ----- %
% sensor name
params.sensor1.name = 'Wheel encoders';
% full file name and label to look for
params.sensor1.datafile = 'atrium.cnt';
params.sensor1.label = 'E';
% is information in file relative 0: no, 1: yes
params.sensor1.isrelative = 1;
% index string
params.sensor1.indexstr = '1,2,3,4';
% robot odometry error model
params.sensor1.kl = 0.00001;     % error growth factor for left wheel in [1/m]
params.sensor1.kr = 0.00001;     % error growth factor for right wheel in [1/m]


% ----- Sensor 2 Model and File Settings ----- %
% sensor name
params.sensor2.name = 'Sick LMS200 indoor';
% full file name and label to look for
params.sensor2.datafile = 'atrium.scn';
params.sensor2.label = 'S';
% temporal and spatial downsampling factor
params.sensor2.tdownsample = 5;
params.sensor2.sdownsample = 1;
% index string
params.sensor2.indexstr = '1,2,3,4:2:end,5:2:end';
% feature extraction m-file
params.sensor2.extractionfnc = 'extractlines';
% maximal perception radius of sensor in [m]
params.sensor2.rs = 30.0;
% constant range uncertainty in [m]
params.sensor2.stdrho = 0.03;
% robot-to-sensor transform expressed in the
% robot frame with units [m] [m] [rad]
params.sensor2.xs = [0; 0; 0];


% ----- Master Sensor Setting ----- %
% define master sensor
params.mastersensid = 2;


% ----- Robot Model ----- %
% robot name
params.robot.name = 'Scout';
% robot class name
params.robot.class = 'robotdd';
% robot form type (see help drawrobot)
params.robot.formtype = 2;
% robot kinematics
params.robot.b  = 0.50;      % robot wheelbase in [m]
params.robot.rl = 0.10;      % left wheel radius in [m]
params.robot.rr = 0.10;      % right wheel radius in [m]
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
params.threshfidel = 0.2;
% significance level for line fusion
params.fusealpha = 0.99999;   % between 0 and 1
% minimal length a segment must have to be accepted
params.minlength = 0.75;      % in [m]
% heuristic compensation factors for raw data correlatins
params.compensa = 1*pi/180;   % in [rad]
params.compensr = 0.01;       % in [m]
% are the scans cyclic?
params.cyclic = 0;            % 0: non-cyclic or 1: cyclic


% ----- Data Association ----- %
% significance level for NNSF matching
params.alpha = 0.999;


% ----- Slam ----- %
% optional axis vector for global map figure. Useful with infinite lines
params.axisvec = [-14 24 -19 13];