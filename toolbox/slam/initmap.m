%INITMAP Initialize map for experiment.
%   M = INITMAP(MODE,NAME,PARAMS) initializes the map M for a slam or
%   localization experiment. With MODE = 0 the map is prepared for a
%   slam experiment: a map M with name NAME is created, a robot is
%   created, added to M and set to its initial pose PARAMS.XRINIT,
%   PARAMS.CRINIT. With MODE = 1, the map is prepared for a locali-
%   zation experiment: a map file with name NAME is opened, read in
%   and the robot is set to the initial pose as above.
%
%   The PARAMS structure is defined in the setup file of the experi-
%   ment.
%
%   See also MAP.

% v.1.0, Kai Arras, Nov. 2003, CAS-KTH

function m = initmap(mode,namestr,params),

if ((mode==0)|(mode==1)) & isstr(namestr) & isstruct(params),
  
  if mode == 0,
    
    % create map object
    m = map(namestr,0);
    % create and init robot object
    eval(['r = ',params.robot.class,'(params.robot);']);
    % add robot to global map
    m = addentity(m,r);
    
  else
    
    % open and read map file
    
    % check on success
    % if
    
      % initialize robot
    
    % else
    %   disp('initmap: Map file not found'); m = [];
    % end;
    
    error('initmap: Localization not yet implemented');
  end;
  
else
  error('initmap: Wrong input. Check your arguments.');
end;