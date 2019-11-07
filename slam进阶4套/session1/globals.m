% definitions of global variables
% values for these are set in ginit.m
global PLAN_FIG;		% handle for main plan figure
global WORLD_SIZE; 	% size of the world (for display purposes only).
global LINC;			% increment along which spline path is evaluated.
global DT;				% Sample interval for controller
global TEND;         % Total maximum run time for simulator
global VVEL;			% vehicle velocity

global KP;				% vehicle position error gain
global KO;				% vehicle orientation error gain

global WHEEL_BASE;	% vehicle wheel base (m)
global WHEEL_RADIUS; % nominal wheel radius
global R_OFFSET;		% radar offset along centre axis
global R_MAX_RANGE;  % maximum radar range
global R_RATE;			% rotation rate of radar

global GSIGMA_RANGE 	 % Range SD (m) used for observation generation
global GSIGMA_BEARING % Bearing SD (rads) used for observation generation
global GSIGMA_WHEEL 	 % wheel variance used for control generation
global GSIGMA_STEER   % steer variance used for control generation

global SIGMA_Q			% Multiplicative Wheel Noise SD (percent)
global SIGMA_W			% Additive Wheel Noise SD (rads/s)
global SIGMA_S			% Mutiplicative steer noise SD (percent) 
global SIGMA_G 		% Additive steer noise SD (rads)
global SIGMA_R 		% wheel radius SD noise (m)
global SIGMA_RANGE	% Range Variance (m)
global SIGMA_BEARING % bearing variance (rads)



