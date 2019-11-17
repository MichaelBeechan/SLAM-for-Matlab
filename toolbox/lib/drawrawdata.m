 %DRAWRAWDATA Draw raw data of sensors.
%   DRAWRAWDATA(SETUPFILENAME,STARTSTEP,NSTEPS) plots the raw data
%   of the sensors specified in the file SETUPFILENAME, the setup
%   file of the experiment. Starts visualization at step STARTSTEP
%   over NSTEPS.
%
%   As each sensor is unique and requires a specific visualization
%   of its data, this m-file is to be adapted each time a new sen-
%   sor is employed. Further, also in the case when the file syntax
%   of a sensor file or the way it is read in changes (using the
%   index string in the setup file), the m-file needs an adaptation.
%
%   See also READONESTEP, SLAM.

% v.1.0, 09.12.03, Kai Arras, CAS-KTH

function drawrawdata(setupfile,startstep,nsteps);

if isstr(setupfile) & (startstep > 0) & (nsteps > 0),
  
  % Open data files and read in the parameters of the experiment 
  [files, params] = openfiles(setupfile,startstep);

  if files.allopen,
    
    % ----------------------------
    % --- Init and start main loop
    % ----------------------------
    
    % Prepare figure before main loop
    figure(1); clf; hold on; set(gca,'Box','On'); axis equal;
    
    % Create robot for odometry if encoder data exist
    if ~isempty('sensors(1)'),
      r = robotdd(params.robot);
    end;
    
    eof = 0; istep = startstep;
    while (istep < startstep+nsteps) & ~eof,
      
      % -------------------
      % --- Data aquisition
      % -------------------
      
      % Read in data for next step from files. When the end of file
      % is encountered, eof = 1 is returned      
      [eof,sensors] = readonestep(files);
      
      if ~eof,
        disp(' '); disp(['Step ',int2str(istep),'...']);
        
        figure(1);
        title(['Raw data at step ',int2str(istep)]);
        

        % -------------------------
        % --- Plot data of sensor 1
        % -------------------------
                
        % Plot sensor 1: odometry
        if (length(sensors) >= 1) & ~isempty(sensors(1).steps),
          % Determine path given the encoder values
          [r,Fxr,path] = predict(r,sensors(1));
          % Plot path
          reso = 50;
          l = length(path);
          for i = reso+1:reso:l-reso;
            drawrobot(path(i).x,[.8 .8 .8],0);
          end;
          drawrobot(path(1).x,'k',get(r,'formtype'));
          drawrobot(path(l).x,'k',get(r,'formtype'));
          xrobot = path(l).x;
        else
          xrobot = zeros(3,1);
        end;
        
        % -------------------------
        % --- Plot data of sensor 2
        % -------------------------
        
        % Plot sensor 2: range finder data
        if (length(sensors) >= 2) & ~isempty(sensors(2).steps),
          for i = 1:length(sensors(2).steps.data2),
            xsp = [sensors(2).steps.data2(i); sensors(2).steps.data3(i);0];
            xwp(1:3,i) = compound(xrobot,compound(sensors(2).params.xs,xsp));
          end;
          plot(xwp(1,:),xwp(2,:),'k.','MarkerSize',4);
        end;
        
        % -------------------------
        % --- Plot data of sensor 3
        % -------------------------
        
        % Plot sensor 3: reflector/beacon data
        if (length(sensors) >= 3) & ~isempty(sensors(3).steps),
          for i = 1:length(sensors(3).steps.data2),
            xsp = [sensors(3).steps.data2(i); sensors(3).steps.data3(i);0];
            xwb(1:3,i) = compound(xrobot,compound(sensors(2).params.xs,xsp));
          end;
          plot(xwb(1,:),xwb(2,:),'r.','MarkerSize',8);
        end;
        
        % -------------------------
        % --- Plot data of sensor i
        % -------------------------
        
        % Plot sensor i: data of your sensor
        % if (length(sensors) >= i) & ~isempty(sensors(i).steps),
        %    ... code to visualize the data of your sensor ...
        % end;
                
        % -------------------------

        disp(['Step ',int2str(istep),' finished']);
        istep = istep + 1;
        drawnow;
      end;
    end;
    closefiles(files);
    
  else
    disp('drawrawdata: Cannot open files or files not found');
  end;
else
  disp('drawrawdata: Wrong input syntax. Check your arguments');
end;