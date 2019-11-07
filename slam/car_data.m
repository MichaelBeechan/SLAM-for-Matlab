%Function to read and transform the raw data from the car to Eduardo's configuration.
%Eduardo Nebot. 
%5/7/02

function car_data

FileUTE='data/Cp_16_05_01/juan3_etc.mat' ;          %Read File                                          
FileGPS='data/Cp_16_05_01/juan3_gps.mat' ; 
FileLASER='data/Cp_16_05_01/juan3_lsr2.mat';

T0=45;TF=170;                                          %Select data set between T0 and TF
        
[TimeGPS,GPSLon,GPSLat] = ReadGpsData(FileGPS) ;       %Read Data set
[Time_VS,Steering,Velocity] = ReadUteData(FileUTE) ;
[TimeLaser, Laser, Intensity]=ReadLaserData(FileLASER);

To=min([Time_VS(1),TimeLaser(1),TimeGPS(1)]);
TimeLaser=TimeLaser-To;
Time_VS=Time_VS-To;                 %Init time --> 0
TimeGPS=TimeGPS-To;    

[ti,Ii]=FINDT(TimeGPS,T0);          %Selecting datas between TO and TF
[tf,If]=FINDT(TimeGPS,TF);
TimeGPS=TimeGPS(Ii:If);
GPSLon=GPSLon(Ii:If);
GPSLat=GPSLat(Ii:If);
clear  Ii If ti tf;

[tis,Iis]=FINDT(Time_VS,T0);
[tfs,Ifs]=FINDT(Time_VS,TF);
Time_VS=Time_VS(Iis:Ifs);
Steering=Steering(Iis:Ifs);
Velocity=Velocity(Iis:Ifs);
clear Iis Ifs tis tfs;

[ti,Ii]=FINDT(TimeLaser,T0);       
[tf,If]=FINDT(TimeLaser,TF);
TimeLaser=TimeLaser(Ii:If)';
Laser=Laser((Ii:If),:);
Intensity=Intensity((Ii:If),:);
clear Ii If ti tf;

%-------------------------------------------------------------------------------------------
%----Mixed time stamp vector (Task manager)-------------------------------------------------
Time=[TimeGPS ,Time_VS, TimeLaser];
%---Flags:  1:GPS   2: Veloc/Steer.   3:Laser------------------
Sensor=[ones(size(TimeGPS)) 2*ones(size(Time_VS)) 3*ones(size(TimeLaser))];
[Time,ii]=sort(Time);
Sensor=Sensor(ii);
Index=[1:(length(TimeGPS)) 1:(length(Time_VS)) 1:(length(TimeLaser))];
Index=Index(ii);
%----------------------------------------------------------------------------------------

save data_set.mat Velocity Steering Time_VS GPSLat GPSLon TimeGPS Laser Intensity TimeLaser Time Sensor Index;

return;

%Auxiliary functions
% ...................................................................
function [GPSTIME,LONG,LAT] =ReadGpsData(file)
    load(file) ;                        %This function is reading the gps long and lat, and transforming these to meters
    LONG = GPS(:,4)' ;
    LAT  = -GPS(:,3)' ;
    GPSTIME = GPS(:,1)'/1000 ;

    LAT0  = -33.8884;          %any point on the map
    LONG0 = 151.1948;

    a =  6378137.0; b  = a*(1-0.003352810664747);
    kpi = pi/180 ;
    cf = cos(LAT0*kpi) ; sf = abs(sin(LAT0*kpi)) ;
    Ro = a*a*cf/abs(sqrt(a*a*cf*cf + b*b*sf*sf))  ;
    RR = b/a  * abs(sqrt( a*a-Ro*Ro))/sf ;

    LAT =(LAT - LAT0 )*RR*kpi   ;
    LONG=(LONG- LONG0)*Ro*kpi   ;
return ;
% ...................................................................
function [Time,Steering,Velocity] = ReadUteData(file)
    load(file) ;
    STEERING = SENSORS(:,4)' ;
    SPEED1   = SENSORS(:,6)' ;
    Time     = SENSORS(:,1)'/1000 ;
    
   %Sensors parameters
    KV1 = 0.024970*(1-0.21);        % speed sensor gain
    KA1 = 0.00040*(1+0);            % steering sensor gain
    KA0 = 2022;                     % steering sensor offset  2000
    Kx1 = 1.0127  ; Kx2=0.0042 ;  
    
    Velocity=SPEED1*KV1 ; 
    Steering=Kx1*(STEERING-KA0)*KA1+Kx2 ;              %SPEED IN m/s, stearing in rads.
       
return ;
% ...................................................................
function [TimeLaser, Range, Intensity] =ReadLaserData(file)

    load(file);
    TimeLaser=double(TLsr)/1000;
    
    Mask13 = uint16(2^13 -1) ;                              %Masks to get the range and intensity vectors
    MaskA  = bitcmp(Mask13,16) ;
    Range=zeros(size(LASER)); Intensity=zeros(size(LASER));
    for i=1:size(LASER,1)
        Laser1=LASER(i,:);
        RR = double(  bitand( Mask13,Laser1) ) ;             %range
        II  = uint16(  bitand( MaskA ,Laser1) ) ;            %intensity, >0, high intensity
        RR = RR/100 ;           %cm ---> metros
        Range(i,:)=RR;
        Intensity(i,:)=II;
    end
return
% ...................................................................
function [t,I]=FINDT(Var,ttt)
    ii=find(Var>=ttt);
    I=ii(1);
    t=Var(I);
return;
% ...................................................................
