%SLAM   Simultaneous localization and mapping.
%    M = SLAM(SETUPFILENAME,STARTSTEP,NSTEPS,DISPLAYMODE) builds a stochas-
%    tic map from the sensor data specified in the setup file SETUPFILENAME.
%    The setup file contains the names of all sensor data files, the robot
%    model, the sensor models and the experimental and algorithmic para-
%    meters of the experiment. This information is The setup file is in 
%
%    Execution is started at STARTSTEP and iterates NSTEPS times. DISPLAY-
%    MODE is between 0 and 4. With 0 the algorithm runs through, with 1 the
%    global map is drawn at each step, and paused if DISPLAYMODE = 2. with
%    DISPLAYMODE = 3, the global and the local map is drawn, and paused if
%    DISPLAYMODE = 4.
%
%    See also DRAWRAWDATA.

% Copyright (c) 2004, CAS-KTH. See licence file for more info.
% v.1.0, Dec.2003, Kai Arras

function G = slam(setupfile,startstep,nsteps,dispmode);

% ----------------
% --- Init session
% ----------------

if isstr(setupfile) & (startstep>0) & (nsteps>0) & ((dispmode>=0)|(dispmode<=1)),
  
  % Open data files, put the file reader according to
  % startstep and read in experimental parameters
  [files,params] = openfiles(setupfile,startstep);
  
  if files.allopen,
    
    % ----------------------------
    % --- Init and start main loop
    % ----------------------------
        
    G = initmap(0,'global map',params);
    eof = 0; istep = startstep;
    while (istep < startstep+nsteps) & ~eof,
      
      % -------------------
      % --- Data aquisition
      % -------------------
      
      % Read in new data for next step from sensor data. When the end of file
      % is encountered, eof = 1 is returned
      [eof,sensors] = readonestep(files);
      
      if ~eof,
        disp(' '); disp(['Step ',int2str(istep),'...']);
        set(G,'time',istep);
        Gin = G;
        
        % --------------------
        % --- State prediction
        % --------------------
        
        % Get the robot object
        r = getrobot(Gin);
        
        % Given the robot at its initial pose and the encoder data in sensors(i)
        % the predict method performs the state prediction of the robot. It re-
        % turns the new pose, its covariance matrix, the Jacobian of the process
        % model derived with respect to the robot and a 3xn matrix PATH of all
        % poses between xr and xrout
        [r,Frout,path] = predict(r,sensors(1));
      
        % Predict the map given the predicted robot and the Jacobian FROUT
        Gin = setrobot(Gin,r);
        
        % Predict the map given the predicted robot and the Jacobian FROUT
        Gin = robotdisplacement(Gin,get(r,'x'),get(r,'C'),Frout);
        
        % ---------------
        % --- Observation
        % ---------------
        
        % Extract features from the raw measurements in data structure given the 
        % extraction algorithm parameters in PARAMS. The local map L is returned
        for i = 1:length(sensors),
          if ~isempty(sensors(i).params.extractionfnc),
            if dispmode >= 3, str = '1'; else str = '0'; end;
            
            % Compound string to be executed. Generates for example
            % L = extractbeacons(sensors(2).steps,params,1);
            exestr = ['L = ',sensors(i).params.extractionfnc,'(sensors(',int2str(i), ...
                      '),params,',str,');'];
            % Execute string as command (Matlab is an interpreted language)
            eval(exestr);
            
          end;
        end;

        % --------------------------
        % --- Measurement Prediction
        % --------------------------
        
        % Predict the map G at the current robot pose, its uncertainty and the
        % robot-to-sensor displacement in PARAMS.
        [Gpred,Hpred] = predictmeasurements(Gin);
        
        % ------------
        % --- Matching
        % ------------
        
        % Apply the nearest neighbor standard filter to match the observations in
        % the local map L to the predicted measurements GPRED and accept the 
        % pairing on the level alpha in PARAMS.
        [nu,R,H,associations] = matchnnsf(Gpred,Hpred,L,params);
                
        % --------------
        % --- Estimation
        % --------------
        
        % Update the map with an extended Kalman filter based on the stacked
        % innovation vector nu and the stacked observation covariance matrix R.
        G = estimatemap(Gin,nu,R,H);
        
        % ------------------------------
        % --- Integrate new observations
        % ------------------------------
        
        % Add the non-associated observations marked by a -1 as the global matching 
        % feature index in ASSOCIATIONS to the map and return the augmented map
        G = integratenewobs(G,L,associations);
        
        % ------------------
        % --- Visualize step
        % ------------------
        
        if dispmode >= 1,
          figure(1); clf; hold on; set(gca,'Box','On'); axis equal;
          title(['Global map at step ',int2str(istep)])
          draw(G,1,1,0,'k');
          if isfield(params,'axisvec'); axis(params.axisvec); end;
          if (dispmode == 2) | (dispmode == 4), pause; end;
          drawnow;
        end;
        
        disp(['Step ',int2str(istep),' finished']);
        istep = istep + 1;
      end;
    end;
    
    % --------------------------
    % --- Visualize final result
    % --------------------------
    
    figure(1); clf; hold on; set(gca,'Box','On'); axis equal;
    title(['Final map at step ',int2str(istep-1)])
    draw(G,1,1,0,'k');
    if isfield(params,'axisvec'); axis(params.axisvec); end;
    
    figure(2); clf; axis square;
    drawcorr(G,1);
    closefiles(files);
    
  else
    disp('slam: Cannot open files or files not found'); G = [];
  end;
else
  disp('slam: Wrong input syntax. Check your arguments'); G = [];
end;
