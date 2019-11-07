function x=slam
% Basic Simultaneous Localisation and Mapping Algorithm usign EKF using Encoder and Laser
%  Juan Nieto         j.nieto@acfr.usyd.edu.au
%  Eduardo Nebot      nebot@acfr.usyd.edu.au
%  More information   http://acfr.usyd.edu.au/homepages/academic/enebot/summer_sch.htm 
%
%
%EkfSlam, this file is using "Nearest Neighbour" data association

close all; clear all;

%Beacons Positions, taken with a kinematic GPS ( 2cm ), used only to Compare results
global beacons;
FileBEACON='beac_juan3.mat';
load(FileBEACON);
beacons=estbeac; clear estbeac;

DeltaT=1;        
T0=0;
TF=112;     % max = 112 secs;

global GPSLon GPSLat

load('data_set');   % File with data stored according to spec provided

%-----------------------------------------------------
To=min([TimeGPS(1),Time_VS(1),TimeLaser(1)]);
TimeLaser=TimeLaser-To;
Time_VS=Time_VS-To;                 %Init time --> 0
TimeGPS=TimeGPS-To;
Time=Time-To;
%-----------------------------------------------------
[tf,If]=FINDT(TimeGPS,TF);% to plot the gps data till TF 
GPSLon=GPSLon(1:If);
GPSLat=GPSLat(1:If);

%----------------------------------------------------------------------------------------
%Prepare matrices to save data: f( Number of predictions + Number of updates Laser 
%                                  + Number of updates GPS)
global xest Pest TimeGlobal FlagS innov innvar;

numberbeacons=50;
NumPred=size(Time,2);
NumUpdaL=size(TimeLaser,2);
NumUpdaG=size(TimeGPS,2);

xest=zeros(3,NumPred+2*NumUpdaL+NumUpdaG);
Pest=zeros(numberbeacons,NumPred+2*NumUpdaL+NumUpdaG);
innov=zeros(2,2*(NumUpdaL+NumUpdaG));
innvar=zeros(2,2*(NumUpdaL+NumUpdaG));
TimeGlobal=zeros(1,NumPred+2*NumUpdaL+NumUpdaG);
FlagS=zeros(1,NumPred+2*NumUpdaL+NumUpdaG);          %This flag is used to know if we 
                                                     %saved an update or a prediction

%----------For the the Jacobians, states and covariances--------------------
global Pp Jh xp 

Pp=zeros(2*numberbeacons+3,2*numberbeacons+3);
Jh=zeros(2,2*numberbeacons+3);
xp=zeros(2*numberbeacons+3,1);
MatrixA=zeros(2*numberbeacons+3,2*numberbeacons+3);        %Auxiliar matrix for J*Pest*J'
MatrixB=zeros(2*numberbeacons+3,2*numberbeacons+3);

%-------------On Line Plot-----------------------------------------------------------------
global FlagWait FlagEnd hhh;
FlagWait = 0 ;
FlagEnd =0 ;

figure(10) ;clf ; 
hold on;
uicontrol('Style','pushbutton','String','PAUSE','Position',[10 5 50 30], 'Callback', 'fOnOff(1);');
uicontrol('Style','pushbutton','String','END  ','Position',[10 5+35 50 30], 'Callback', 'fOnOff(2);');

title('EKFSlam');xlabel('East (meters)');ylabel('North (meters)');
plot(GPSLon,GPSLat,'r.');axis([-10,20,-25,20]);%axis([2,33,-25,25]);%
plot(beacons(:,1),beacons(:,2),'b*')
hhh(1)=plot(0,0,'b','erasemode','none') ;   %path estimated
hhh(2)=plot(0,0,'r','erasemode','xor') ;   %what is used from the frame
hhh(3)=plot(0,0,'b.','erasemode','xor') ;   %laser, all the frame
hhh(4)=plot(0,0,'r+','erasemode','xor') ;   %high intensity only
hhh(5)=plot(0,0,'r','erasemode','xor') ;   %covariance ellipse x-y position
hhh(6)=plot(0,0,'r','erasemode','xor') ;   %covariance ellipse x-y beacon
hhh(7)=plot(0,0,'r','erasemode','xor') ;   %covariance ellipse x-y beacon

hhh(8)=plot(0,0,'sr','erasemode','xor') ;   %car
hhh(9)=plot(0,0,'go','erasemode','xor') ;   %beacons' position estimated
legend('GPS','Beacons','Estimated Path','Laser Data','All laser','H. Inten.')

hold off;

%-----------------------------------------------------------------
% Filter Tuning
% These are the parameter you need to modify to improve the operation
% of the filter  ( Good Luck :-) )
%
global sigmaU sigma_laser sigma_gps;

%Internal Sensors  ( dead - reckoning )
    sigmastear=(7)*pi/180;        %Qu=7
    sigmavel=0.7;                 %Qv=0.7
    
%Observations:  laser Range and Bearing   ( Sick laser )
%               We are estimating the centre of a 6 cm pole
    SIGMA_RANGE=0.10;             %Rr=0.1  
    SIGMA_BEARING=(1)*pi/180;     %Ro=1
    
% Observations: GPS
% This is only used at the beginning to estimate absolute heading
% and then compare the localisation results with GPS
    sigmagps=0.05;            
    
    
% sensors error covariance
    sigmaU=[sigmavel*sigmavel       0;
                0             sigmastear*sigmastear];
    
    sigma_laser=[SIGMA_RANGE^2     0;
                0          SIGMA_BEARING^2]  ;            
    
    sigma_gps=[sigmagps*sigmagps     0;
                0          sigmagps*sigmagps]  ;          


%--------------Initial conditions & some constants----------------------------------------

global Pt isave index_update beacon2show tglobal trefresh plotall;   %trefresh is to refresh 
                                                                     %the path in the plot

finit=-112*pi/180; % or you could use something like: atan2(GPSLat(2)-GPSLat(1),GPSLon(2)-GPSLon(1));

xinit=[GPSLon(1);GPSLat(1);finit];

Pinit= [0.1    0.0   0.0   ;
        0.0   0.1    0.0   ;
        0.0   0.0    (15)*pi/180  ];

u=[Velocity(1) ; Steering(1) ];  

FlagStates=[-1;-1;-1];      %Initialization of flags to count the number of "hits" of each beacon

Pt=3;           %Pointer to the last state, at the beggining we have the three model's states  
t1=cputime; trefresh=T0+2;
iglobal=0; isave=1; index_update=1; tglobal=0;
xp(1:Pt)=xinit; Pp(1:Pt,1:Pt)=Pinit;
plotellipse=0;         %Flag to plot the covariance of the vehicle and some landmarks  
                       % 1: plot  0: no plot
plotall=1;             %check in the plot function
beacon2show=[4 5];     %These are the beacons which the covariance ellipse will be show
                       %In this example only two beacons are selected.

                       
%-----------------------------------Running filter------------------------------------------
disp('Running filter...')


%**************************  Navigation Loop Start **************************************

while (tglobal<TF)
    iglobal=iglobal+1;
    tglobal=Time(iglobal);
    if (iglobal>1)
        dt=tglobal-Time(iglobal-1);
    else
        dt=0.025;
    end
    
    %Perform a prediction with delta = previous time - actual time
    
    pred(dt,u);                                          %Prediction
    SaveStates(xp(1:3),diag(Pp(1:Pt,1:Pt)),tglobal,0);   %save data
    set(hhh(1),'XData',xp(1),'YData',xp(2)) ;
    if plotellipse
        plotCovariance; %plot the covariance ellipse (1-sigma)
    else  
        set(hhh(8),'XData',xp(1),'YData',xp(2)) ;
    end
    
    %New Information, If External: do update, if dead-reckioning : set u for next predition
    
    %------------------------------------------------------------------------------------------------------------------------      
    %  GPS is sensor 1, Only used for DeltaT to evaluate initial heading !!
    if (Sensor(iglobal)==1) & (tglobal<(T0+DeltaT))                     
        %GPS
        zgps=[GPSLon(Index(iglobal));GPSLat(Index(iglobal))];
        [in ins]=update_gps(zgps);
        SaveStates(xp(1:3),diag(Pp(1:Pt,1:Pt)),tglobal,1); SaveInnov(in,diag(ins));
    end 
    
    
    %------------------------------------------------------------------------------------------------
    %Sensor =2 are Dead reckoning sensors

    if Sensor(iglobal)==2 
        %Sensors
        u=[Velocity(Index(iglobal)) ;Steering(Index(iglobal))];    %SPEED IN m/s, stearing in rads.
    end
    
    %-----------------------------------------------------------------------------------------------
    % Sensor = 3 is the Laser   

    if (Sensor(iglobal)==3) & (tglobal>(T0+DeltaT))
       %Laser
       bias=0*pi/180;
       [LASERr LASERo RR a]=getdata(Laser(Index(iglobal),:), Intensity(Index(iglobal),:));  %estimate beacon centre
       zlaser=[LASERr ; LASERo+bias];          
       %------------------------------------------------------------------------------------------------
       laserview(RR,a,LASERr,LASERo);        %plot the laser frame
       
       %------------------------Update--------------------------------------------------------------------
       for w=1:size(LASERr,2)    
        index1=0;
        if Pt==3                % this is the first beacon and will be incorporated
                                % this can be improved building a list to avoid spurious observ.
            new_state(zlaser(:,w));
            Pt=Pt+2;            %pointer to the last state in the s.v.
            FlagStates(Pt-1:Pt)=1;
            [index1,in,ins]=asoc_update(zlaser(:,w),(Pt-1),1);       %Update of the new state
            SaveStates(xp(1:3),diag(Pp(1:Pt,1:Pt)),tglobal,1);       %save states
            SaveInnov(in,diag(ins));                                 %save innovations
            set(hhh(1),'XData',xp(1),'YData',xp(2)) ;                % on line plot
        else        
            [closest]=Zone_Probe(zlaser(:,w));       %if not first association is needed ( look only in reduced area )
            closest=4+2.*(closest-1);                %pointer to the X beacons position in the state vector
            j=1;i=0; qu=[];possible=[];
            while (j<=length(closest))                    
                i=closest(j);
                [index1,in,ins,q1]=asoc_update(zlaser(:,w),i,0);    %q1 is the likelihood value, assoc only here
                if index1==1
                    possible=[possible i];
                    qu=[qu q1];
                end
                j=j+1;
            end
            if ~isempty(possible)     
                if length(possible)>1
                    disp('Multi hypothesis problem');        % this may be a problem !
                end
                [value,index2]=min(qu);
                twin=possible(index2);                             %nearest nighbour==max. likelihood
                FlagStates(twin:twin+1)=FlagStates(twin:twin+1)+1; 
                [index1,in,ins]=asoc_update(zlaser(:,w),twin,1);     % perform the update with best
                SaveStates(xp(1:3),diag(Pp(1:Pt,1:Pt)),tglobal,1);
                SaveInnov(in,diag(ins));
                set(hhh(1),'XData',xp(1),'YData',xp(2)) ;
            else           
                new_state(zlaser(:,w));                 
                Pt=Pt+2;                
                FlagStates(Pt-1:Pt)=1;
                [index1,in,ins]=asoc_update(zlaser(:,w),Pt-1,1);         %Update of the new state
            end
        end    
                  
      end
  end   
  
  
  while FlagWait,
      if FlagEnd, return  
      end  		                %This is for the buttons of "pause" and "end" in the animation plot
      pause(0.5) ;
  end;
  if FlagEnd; hold on;plot(xest(1,1:isave-1),xest(2,1:isave-1),'b');hold off; return 
  end  
end

%************************ Navigation Loop End **********************************

xest=xest(:,1:isave-1); Pest=Pest(:,1:isave-1);
innov=innov(:,1:index_update-1); innvar=innvar(:,1:index_update-1);
FlagS=FlagS(:,1:isave-1);
TimeGlobal=TimeGlobal(:,1:isave-1);


disp('Completed Filtering:')
t2=cputime;                     %To know the real time of the algorithm
treal=TF-T0,
time=t2-t1,
taverage=(t2-t1)/iglobal, 
%----------------------------Fiter completed --------------------------------------

%This is to select just the beacons we saw more than "hits" times. ( for display purposes
global estbeacons
hits=4;
aux=FlagStates(4:2:Pt);
ii=find(aux>=hits);
xpos=4+2.*(ii-1);
estbeacons(:,1)=xp(xpos) ; estbeacons(:,2)=xp(xpos+1); 
numbeac=size(estbeacons,1);


plots;

return;
%--------------------------------------------------------------------------------------------------------------------------------------
%---------------------------------End of the main function-----------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------------------



%------------------------------------------------------------------------------
%      Auxiliary functions
%-------------------------------------------------------------------------------

function pred(dt,u)
% Function to generate a one-step vehicle prediction .
    global Pt;
    global Pp xp MatrixA MatrixB;
    global sigmaU;
    %----------------------------------------------------------------------
    %Car parameters
    L=2.83 ; h=0.76;  b = 1.21-1.42/2;  a = 3.78;   
    %-----------------------------------------------------------------------
    XSIZE=Pt; N=(Pt-3)/2;     %Pt=3+2*N
    
    % input error transfer matrix      (df/du)
    ve=u(1);
    vc=ve/(1-tan(u(2))*h/L);          %The velocity has to be translated from the back
                                      %left wheel to the center of the axle
    dvc_dve=(1-tan(u(2))*h/L)^-1;
    dvc_dalpha=ve*h/(L*(cos(u(2)))^2*(1-tan(u(2))*h/L));
    aux=(cos(u(2))^(-2));
    T1=a*sin(xp(3))+b*cos(xp(3));
    T2=a*cos(xp(3))-b*sin(xp(3));

    b1=(cos(xp(3))-tan(u(2))/L*T1)*dvc_dve;
    b3=(sin(xp(3))+tan(u(2))/L*T2)*dvc_dve;
    b5=tan(u(2))/L*dvc_dve;
    b2=-T1*vc/L*aux+b1*dvc_dalpha;
    b4=T2*vc/L*aux+b1*dvc_dalpha;
    b6=vc/L*aux+tan(u(2))/L*dvc_dalpha;

    Bv=dt*[b1   b2;
          b3   b4;
          b5   b6];

% state transition matrix evaluation    (df/dx) -------------------------------
    J1=[1 0 -dt*(vc*sin(xp(3))+vc/L*tan(u(2))*(a*cos(xp(3))-b*sin(xp(3))))       
        0  1  dt*(vc*cos(xp(3))-vc/L*tan(u(2))*(a*sin(xp(3))+b*cos(xp(3))))       %Jacobian
        0  0                              1                               ];  
        I=eye(Pt-3,Pt-3);             

% first state prediction -------------------------------------------------------

    xp(1)=xp(1) + dt*vc*cos(xp(3))-dt*vc/L*tan(u(2))*(a*sin(xp(3))+b*cos(xp(3)));
    xp(2)=xp(2) + dt*vc*sin(xp(3))+dt*vc/L*tan(u(2))*(a*cos(xp(3))-b*sin(xp(3)));         
    xp(3)=xp(3) + dt*vc/L*tan(u(2));
    xp(3)=NormalizeAngle(xp(3));

%J*Pest*J' ---------------------------------------------------------------------
    P1=Pp(1:3,1:Pt);
    P2=Pp(4:Pt,1:Pt);
    Aux=[J1*P1
        I*P2];
    Aux1=Aux(1:3,1:3); Aux2=Aux(1:3,4:Pt); Aux3=Aux(4:Pt,1:3); Aux4=Aux(4:Pt,4:Pt);

    MatrixA(1:Pt,1:Pt)=[Aux1*J1' Aux2*I
                        Aux3*J1' Aux4*I];
    clear Aux Aux1 Aux2 Aux3 Aux4;
%---------------------------------------------------------------------------------

%B*sigmaU*B'----------------------------------------------------------------------
    MatrixB(1:Pt,1:Pt)=[Bv*sigmaU*Bv'  zeros(3,Pt-3)
                            zeros(Pt-3,Pt)        ];
%---------------------------------------------------------------------------------     
    Pp(1:Pt,1:Pt)= MatrixA + MatrixB;
return;


%---------------------------------------------------------------------------------------------------------------------------------------    
%Update with GPS data
function [innov, S]=update_gps(zgps)
    global xp Pp Pt
    global sigma_gps;

    H=zeros(2,Pt); H(1,1)=1; H(2,2)=1;

    S=H*Pp(1:Pt,1:Pt)*H' + sigma_gps;           
    W=Pp(1:Pt,1:Pt)*H'* inv(S);
    Pp(1:Pt,1:Pt)=Pp(1:Pt,1:Pt)-W*S*W';
    innov=[zgps-H*xp(1:Pt)];
  
    xp(1:Pt)=xp(1:Pt)+W*innov;
return;


%---------------------------------------------------------------------------------------------------------------------------------------    
% This function perfor association or update accoding to the value of updatee
% updatee=0 -> association only, updatee=1 -> association and update
function [index,innov, S, q1]=asoc_update(zlaser,pointer,updatee)
    global Pt;
    global Pp xp Jh;
    global sigma_laser;
 
    beacon=[xp(pointer) xp(pointer+1)];       %Xi,Yi
    dx=xp(1)-beacon(1);
    dy=xp(2)-beacon(2);
    d=(dx^2+dy^2)^0.5;

    Jh(1:2,1:3)=[dx/d     dy/d      0;
                -dy/(d^2) dx/(d^2) -1];
    Jh(1:2,4:Pt)=zeros(2,(Pt-3));    
    Jh(1:2,(pointer):(pointer+1))=[-dx/d -dy/d ; dy/(d^2) -dx/(d^2)];

    H=[d ; atan2((beacon(2)-xp(2)),(beacon(1)-xp(1)))-xp(3) + pi/2];         %h(xpred)
                                                                       
    H(2)=NormalizeAngle(H(2));
    S=Jh(1:2,1:Pt)*Pp(1:Pt,1:Pt)*(Jh(1:2,1:Pt))' + sigma_laser;           
    innov=[zlaser-H];       
    innov(2)=NormalizeAngle(innov(2));

    if updatee==1                                    %is an update, if this flag is zero is an asociation 
        W=Pp(1:Pt,1:Pt)*(Jh(1:2,1:Pt))'* inv(S);
        Pp(1:Pt,1:Pt)=Pp(1:Pt,1:Pt)-W*S*W';          %Update of the error covariance matrix
        xp(1:Pt)=xp(1:Pt)+W*innov;
        xp(3)=NormalizeAngle(xp(3));
        index=0;  q1=0; 
    else
    
        chi=5.99;       %95% confidence            
        q=(innov')*(inv(S))*innov;
        if (q<chi)          %Chi square test 
            index=1;       
            q1=q+log(det(S));
        else
            index=0; q1=0;
        end;
        clear q W; 
    end
return;


%---------------------------------------------------------------------------------------------------------------------------------------    
% Insert a new state assigning a large error ( simpler approach )
function new_state(zlaser)
    global Pt xp Pp;

    %First of all, calculate position beacon in the cartesian global coordiante.
    xx = xp(1)+zlaser(1)*cos(zlaser(2)+xp(3)-pi/2) ;yy = xp(2)+zlaser(1)*sin(zlaser(2)+xp(3)-pi/2) ; 

    xp(Pt+1)=xx;
    xp(Pt+2)=yy;
    clear xx yy;

    Pp(Pt+1,1:(Pt))=0;          %x row
    Pp(1:Pt,Pt+1)=0;            %x column
    Pp(Pt+1,Pt+1)=10^6;         %x diagonal

    Pp(Pt+2,1:(Pt+1))=0;        %y row
    Pp(1:Pt+1,Pt+2)=0;          %y column
    Pp(Pt+2,Pt+2)=10^6;         %y diagonal  ( this may introduce numerical problems if not choosen properly )

return;

%---------------------------------------------------------------------------------------------------------------------------------------    
%Function to find index in data between TO and TF
function [t,I]=FINDT(Var,ttt)
    ii=find(Var>=ttt);               
    I=ii(1);
    t=Var(I);
return;

%---------------------------------------------------------------------------------------------------------------------------------------    
%function for the on-line plot 
function fOnOff(x)                                          
    global FlagWait FlagEnd;
    if x==1, FlagWait=~FlagWait ; return ; end ;
    if x==2, FlagEnd=1 ; return ; end ;
return ;

%---------------------------------------------------------------------------------------------------------------------------------------
%Transform GPS lat and Long to local navigation frame centred at a reference pt
function [GPSTIME,LONG,LAT] =ReadGpsData(file)
    load(file) ;
    file;
    LONG = GPS(:,4)' ;
    LAT  = -GPS(:,3)' ;           %We are in the south, the latitude is negative
    GPSTIME = GPS(:,1)'/1000 ;

    LAT0  = -33.8884;          %put any point on the map, is not a good idea to put "magic numbers" (as in this case), the best 
    LONG0 = 151.1948;          %would be to take the average of the initial points
    
    a =  6378137.0; b  = a*(1-0.003352810664747);         %Linalization from latitude and long. to meters in a local area
    kpi = pi/180 ;
    cf = cos(LAT0*kpi) ; sf = abs(sin(LAT0*kpi)) ;
    Ro = a*a*cf/abs(sqrt(a*a*cf*cf + b*b*sf*sf))  ;
    RR = b/a  * abs(sqrt( a*a-Ro*Ro))/sf ;

    LAT =(LAT - LAT0 )*RR*kpi   ;
    LONG=(LONG- LONG0)*Ro*kpi   ;
return ;
%-----------------------------------------------------------------------------------------------------------------------------------------
%read steering data, not used in this case
function [Time,STEERING,SPEED1] = ReadUteData(file)
    load(file) ;
    STEERING = SENSORS(:,4)' ;
    SPEED1   = SENSORS(:,6)' ;
    Time     = SENSORS(:,1)'/1000 ;
return ;


%-----------------------------------------------------------------------------------------------------------------------------------------
%This function perform the estimation of the beacon centre, It can be improved
%There is a more general version: detectrees that works well for all cylindrical
%objects
function [LASERr,LASERo,RR,a]=getdata(laser,intensity)
LASERr=[];                                          
    LASERo=[];
    first=0;
    max_range=30; min_range=1;
    angleDiff=3;
    RR=laser; a=intensity;
    for i=1:361
        if (min_range<RR(i)<max_range) & (a(i)>0)
            primera=0;
            last=[RR(i),i];
            if first==0
                init=[RR(i),i];
                first=1;
            end
        else
            if first==1
                if primera==0
                    primera=1;
                else
                    if (i-last(2))>2
                    first=0;
                    range=mean([init(1),last(1)]);
                    angle=mean([init(2),last(2)]);
                    LASERr=[LASERr range];
                    LASERo=[LASERo (angle-1)/2*pi/180]; 
                    end          
                end
            end
        end
    end
return;

%---------------------------------------------------------------------------------------------------------------------------------
%Is looking for the beacons that are "min_dist" close to te observation
% in this case it is set to 3 meters. Modify if necesary
function   [closest]=Zone_Probe(zlaser);   
    global Pt xp;
    min_dist=3;
    ii=[4:2:Pt-1];
    xx = xp(1)+zlaser(1)*cos(zlaser(2)+xp(3)-pi/2) ;yy = xp(2)+zlaser(1)*sin(zlaser(2)+xp(3)-pi/2) ;   %Position
    d=((xx-xp(ii)).^2+(yy-xp(ii+1)).^2).^0.5;
    iii=find(d<min_dist);
    closest=iii;
    clear xx yy;
    return;
return;


%---------------------------------------------------------------------------------------------------------------------------------
%Plot the laser scan
function laserview(RR,a,LASERr,LASERo)
    global xp hhh;
    global isave xest tglobal trefresh;
    aa = [0:360]*pi/360 ;
    ii=find(RR<50 & RR>1) ;
    aa2=aa(ii) ; xx = RR(ii).*cos(aa2+xp(3)-pi/2) ;yy = RR(ii).*sin(aa2+xp(3)-pi/2) ;     %All points
    set(hhh(3),'XData',xx+xp(1),'YData',yy+xp(2)); 
    pause(0.01);

    ii=find(a>0) ;
    aa2=aa(ii) ; xx = RR(ii).*cos(aa2+xp(3)-pi/2) ;yy = RR(ii).*sin(aa2+xp(3)-pi/2) ;     %High intensity points
    set(hhh(4),'XData',xx+xp(1),'YData',yy+xp(2)); 
    pause(0.01);
              
    ll = length(LASERr) ;
    if ll>0,
        xx = LASERr.*cos(LASERo+xp(3)-pi/2) ;               %The points we are taking from one frame
        yy = LASERr.*sin(LASERo+xp(3)-pi/2) ;
        set(hhh(9),'XData',xx+xp(1),'YData',yy+xp(2));
        
        index=[1:3:3*ll];
        xpoints=zeros(3*ll,1); ypoints=zeros(3*ll,1);           %this is to plot the lines between the beacons and the car
        xpoints(index)=xp(1); ypoints(index)=xp(2);
        xpoints(index+1)=xx+xp(1); ypoints(index+1)=yy+xp(2);
        xpoints(index+2)=NaN;ypoints(index+2)=NaN;
        set(hhh(2),'XData',xpoints,'YData',ypoints)
        pause(0.01);
    else
        set(hhh(2),'XData',0,'YData',0)
    end ;
    if (tglobal-trefresh)>2                                             %every "trefresh" seconds is doing s refresh of the whole path
        set(hhh(1),'XData',xest(1,1:isave-1),'YData',xest(2,1:isave-1))
        trefresh=tglobal;    
    end
 return;

 %---------------------------------------------------------------------------------------------------------------------------------
% saving the state
function SaveStates(states,diagcov,times,Flag)
    global isave xest Pest TimeGlobal Pt FlagS;
    xest(:,isave)=states;
    Pest(1:Pt,isave)=diagcov;
    TimeGlobal(1,isave)=times;
    FlagS(1,isave)=Flag;
    isave=isave+1;
return;

%----------------------------------------------------------------------------------------------------------------------------------
%saving innovations
function  SaveInnov(in,ins);
    global innov innvar index_update;
    innov(:,index_update)=in;
    innvar(:,index_update)=ins;
    index_update=index_update+1;
return;

%----------------------------------------------------------------------------------------------------------------------------------
%transform angles to -pi to pi
function ang2 = NormalizeAngle(ang1)
    if ang1>pi, ang2 =ang1-2*pi ;  return ; end ;
    if ang1<-pi, ang2 =ang1+2*pi ;  return ; end ;
    ang2=ang1;
return 

%----------------------------------------------------------------------------------------------------------------------------------
%plot 1-sigma uncertainty region for a P covariance matrix.
% Jose-1999
function xxx=ellipse(X0,P,veces,color,figu)


	R = chol(P)';  % R*R'= P, X = R*X2
	r = 1 ;  %circle's radius in space X2 
	aaa = [0:veces]*2*pi/veces ;			% sample angles
	xxx = [ r*cos(aaa) ; r*sin(aaa) ] ; % polar to x2,y2
	xxx = R*xxx ;								% x2,y2 to x,y
	xxx(1,:) = X0(1)+xxx(1,:);				% reference to center X0
	xxx(2,:) = X0(2)+xxx(2,:);
return;

%----------------------------------------------------------------------------------------------------------------------------------
function Rxx=auto(x)        %This is used just for the plot

    [N,nul]=size(x'); 
    M=round(N/2);

    Xpsd=fft(x);
    Pxx=Xpsd.*conj(Xpsd)/N;

    % the inverse is the autocorrelation
    Rxx=real(ifft(Pxx));
    Rxx=Rxx(1:M);
    fact=Rxx(1); 
    for i=1:M
        Rxx(i)=Rxx(i)/fact;
    end
return


%---------------------------------------------------------------------------------------------------------------------------------
%Include all your off-line plots here ( runs when finish )
function plots
    global xest Pest GPSLon GPSLat beacons;
    global innov innvar;
    global FlagS TimeGlobal estbeacons plotall;
    ii=find(FlagS==1);
    timeinnov=TimeGlobal(ii);           %Innovations time stamps

figure(1);clf
plot(xest(1,:),xest(2,:),'c',xest(1,:),xest(2,:),'b.',estbeacons(:,1),estbeacons(:,2),'r*',beacons(:,1),beacons(:,2),'bo',GPSLon,GPSLat,'g.');grid on;
legend('Estimated','Est. Sample','Est. Beac.','Beacons','GPS')
xlabel('East Meters')
ylabel('North Meters')
title('Path')

if plotall
    figure(2);clf
    plot(xest(1,:),xest(2,:),'r');grid on;
    xlabel('East Meters')
    ylabel('North Meters')
    title('Path Estimated')

    figure(3);clf
    hold on
    axis([timeinnov(1) timeinnov(size(timeinnov,2)) -0.5 0.5]);grid on;
    plot(timeinnov(1,:),innov(1,:)), title('Zr Innovations')%
    plot(timeinnov(1,:),2*sqrt(innvar(1,:)),'r')
    plot(timeinnov(1,:),-2*sqrt(innvar(1,:)),'r')
    xlabel('Time(secs)');ylabel('Desviation(m)');
    legend('Innovations','Sta. Desv. Inn. (95%)')
    hold off

    figure(4);clf
    Rxx1=auto(innov(1,:));
    Rxx2=auto(innov(2,:));
    M=round(size(innov,2)/2);
    bounds=2*sqrt(1/(M));
    plot([1:M],Rxx1,'b',[1:M],Rxx2,'r',[1:M],bounds,'g',[1:M],-bounds,'g');grid on;
    title('Autocorrelation of Innovation Sequence')
    legend('Var. Zr','Var. Ztheta','95% Confi. Bounds')

    figure(5);clf
    hold on
    axis([TimeGlobal(1) TimeGlobal(size(TimeGlobal,2)) 0 1]);grid on;
    plot(TimeGlobal,sqrt(Pest(1,:)),'b')
    plot(TimeGlobal,sqrt(Pest(2,:)),'r')
    plot(TimeGlobal,sqrt(Pest(3,:)),'g')
    xlabel('Time(secs)');ylabel('Desviation(m)');
    title('Model Covariance');
    legend('X var.','Y var.','Steer.')
    hold off

    figure(6);clf
    hold on
    axis([TimeGlobal(1) TimeGlobal(size(TimeGlobal,2)) 0 1]);grid on;
    plot(TimeGlobal,sqrt(Pest(4,:)),'b'); plot(TimeGlobal,sqrt(Pest(5,:)),'b.')
    plot(TimeGlobal,sqrt(Pest(8,:)),'r'); plot(TimeGlobal,sqrt(Pest(9,:)),'r.')
    plot(TimeGlobal,sqrt(Pest(12,:)),'g'); plot(TimeGlobal,sqrt(Pest(13,:)),'g.')
    plot(TimeGlobal,sqrt(Pest(16,:)),'m'); plot(TimeGlobal,sqrt(Pest(17,:)),'m.')
    xlabel('Time(secs)');ylabel('Desviation(m)');
    title('Beacons Covariances');
    legend('Beac.1(east)','Beac.1(north)','Beac.3(east)','Beac.3(north)','Beac.5(east)','Beac.5(north)','Beac.7(east)','Beac.7(north)')
    hold off
end
return;
%---------------------------------------------------------------------------------------------------------------------------------
function plotCovariance
    global hhh xp Pp beacon2show Pt;
    xxx=ellipse(xp(1:2),Pp(1:2,1:2),50); set(hhh(5),'XData',xxx(1,:),'YData',xxx(2,:)) ;    %Position 
    if Pt>=(3+2*beacon2show(2))
        xxx=ellipse(xp(4+2*(beacon2show(1)-1):4+2*(beacon2show(1)-1)+1),Pp(4+2*(beacon2show(1)-1):4+2*(beacon2show(1)-1)+1,4+2*(beacon2show(1)-1):4+2*(beacon2show(1)-1)+1),50);
        set(hhh(6),'XData',xxx(1,:),'YData',xxx(2,:)) ;
        xxx=ellipse(xp(4+2*(beacon2show(2)-1):4+2*(beacon2show(2)-1)+1),Pp(4+2*(beacon2show(2)-1):4+2*(beacon2show(2)-1)+1,4+2*(beacon2show(2)-1):4+2*(beacon2show(2)-1)+1),50);
        set(hhh(7),'XData',xxx(1,:),'YData',xxx(2,:)) ;
    end
return;
%---------------------------------------------------------------------------------------------------------------------------------
