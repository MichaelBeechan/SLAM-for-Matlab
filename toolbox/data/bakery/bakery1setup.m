% Experiment set up file for the Matlab Robot Navigation Toolbox 
% Date: 07.12.03
% Author: Kai Arras, CAS-KTH
% Description: The 'bakery1'-data set has been recorded in a former
% industrial bakery building downtown Stockholm. The robot was a
% iRobot ACVR from CAS-KTH with the Hannover 3D sensor. The 2D data
% have been extracted with a projection from 3D removing most clutter
% which would have been visible using a 2D sensor. In this data set,
% the robot revisits its start point three times. The data are a nice
% benchmark for line-based SLAM.
% Odometry of 'Pluto' (the robot) is pretty poor, so kl = kr = 0.001.


% ----- Sensor 1 Model and File Settings ----- %
% sensor name
params.sensor1.name = 'Wheel encoders';
% full file name and label to look for
params.sensor1.datafile = 'bakery1.cnt';
params.sensor1.label = 'E';
% is information in file relative 0: no, 1: yes
params.sensor1.isrelative = 1;
% index string
params.sensor1.indexstr = '1,2,3,4';
% robot odometry error model
params.sensor1.kl = 0.001;     % error growth factor for left wheel in [1/m]
params.sensor1.kr = 0.001;     % error growth factor for right wheel in [1/m]


% ----- Sensor 2 Model and File Settings ----- %
% sensor name
params.sensor2.name = 'Hannover 3D LMS200 outdoor';
% full file name and label to look for
params.sensor2.datafile = 'bakery1.scn';
params.sensor2.label = 'S';
% index string
params.sensor2.indexstr = '1,2,3,end-1:-2:4,end:-2:5';
% feature extraction m-file
params.sensor2.extractionfnc = 'extractlines';
% maximal perception radius of sensor in [m]
params.sensor2.rs = 32.0;
% constant range uncertainty in [m]
params.sensor2.stdrho = 0.04;
% robot-to-sensor transform expressed in the
% robot frame with units [m] [m] [rad]
params.sensor2.xs = [0; 0; -6.5*pi/180];


% ----- Master Sensor Setting ----- %
% define master sensor
params.mastersensid = 2;


% ----- Robot Model ----- %
% robot name
params.robot.name = 'Pluto';
% robot class name
params.robot.class = 'robotdd';
% robot form type (see help drawrobot)
params.robot.formtype = 5;
% robot kinematics
params.robot.b  = 0.60;     % robot wheelbase in [m]
params.robot.rl = 0.25;     % left wheel radius in [m]
params.robot.rr = 0.25;     % right wheel radius in [m]
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
params.fusealpha = 0.99999;    % between 0 and 1
% minimal length a segment must have to be accepted
params.minlength = 1;         % in [m]
% heuristic compensation factors for raw data correlatins
params.compensa = 1*pi/180;   % in [rad]
params.compensr = 0.01;       % in [m]
% are the scans cyclic?
params.cyclic = 1;            % 0: non-cyclic or 1: cyclic


% ----- Data Association ----- %
% significance level for NNSF matching
params.alpha = 0.95;


% ----- Slam ----- %
% optional axis vector for global map figure. Useful with infinite lines
params.axisvec = [-6 23 -32 11];