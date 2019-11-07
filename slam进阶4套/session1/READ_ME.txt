These functions allow generation of a control path and true state
vector for a car-like vehicle.

Functions:
beacons(x,y)=get_beacons(int figure)
path(x,y)=get_path(beacons, int figure)
run
get_control
get_err


some global variables ar set in 'globals'

The function get_beacons allows graphical placement of beacons. 
Returns x,y locations of beacons.

The function get_path allows graphical specification of a path
through point specification and spline fitting. Returns x,y 
specification of path.  

The function run is a script file that runs through the control 
algorithm generating control signals and true path locations.
Run calls get_err, which computes the error between path and vehicle,
and get_control which uses this error to correct vehicle steering.

The output from run are xlog and ulog which are a time list of state
and control vectors in the form:

xlog(i,:)=[x,y,phi,time]
ulog(i,:)=[V,gamma,time]
