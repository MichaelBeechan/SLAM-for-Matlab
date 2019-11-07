% values for global variables
% these are defined in globals.m
PLAN_FIG=1;			% default handle for plan figure
WORLD_SIZE=500;   % 0-100 meters in each direction
LINC=0.1;			% 0.1m length for spline interpolation
DT=0.1;				% Sample interval for controller
TEND=5000*DT;     % Total maximum run time for simulator
VVEL=2;				% Vehicle velocity (assumed constant)

KP=1;					% vehicle position error gain
KO=1;					% vehicle orientation error gain

WHEEL_BASE=1;		% vehicle wheel base (m)
WHEEL_RADIUS=0.3;  % nomial wheel radius (m)
R_OFFSET=0.0;		% radar offset (m)
R_MAX_RANGE=100.0;% maximum range (m)
R_RATE=12.566;		% rotation rate (rads/s)

GSIGMA_RANGE=0.25; 	 % Range SD (m) used for observation generation
GSIGMA_BEARING=0.0174;% Bearing SD (rads) used for observation generation
GSIGMA_WHEEL=0.1; 	 % wheel variance used for control generation
GSIGMA_STEER=0.035;	 % steer variance used for control generation

SIGMA_Q=0.25;			% Multiplicative Wheel Noise SD (percent)
SIGMA_W=0.1;			% Additive Wheel Noise SD (rads/s)
SIGMA_S=0.01;			% Mutiplicative steer noise SD (percent) 
SIGMA_G=0.0087; 		% Additive steer noise SD (rads)
SIGMA_R=0.005; 		% wheel radius SD noise (m)
SIGMA_RANGE=0.3;		% Range Variance (m)
SIGMA_BEARING=0.035; % bearing variance (rads)

fact=0.1;
SIGMA_Q=SIGMA_Q*fact;
SIGMA_W=SIGMA_W*fact;
SIGMA_S=SIGMA_S*fact;
SIGMA_G=SIGMA_G*fact;
SIGMA_R=SIGMA_R*fact;
