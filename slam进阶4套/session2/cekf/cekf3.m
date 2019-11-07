function cekfTest1

% simulate a time interval where it is possible to run a compressed filter.

% ......................................
N=400 ;             % number of states
nObservations=200 ;
% ---- define active states indexes --
iiActiveStates = [1,5,11,55,6,88]; 
% ......................................



LA = length(iiActiveStates) ;
% ---- obtain passive states indexes --
iiActiveStates = int16(iiActiveStates);
ff = int16(zeros(1,N)) ;
ff(iiActiveStates)=1 ;
iiPassiveStates = int16(find(ff==0)) ;
% --------------------------------------
% create some correlated initial condition
%P = randn(N,N) ; 
P = randn(N,1) ;  P = P*P'+ eye(N,N)*0.01; % well correlate matrix

% P is to be used by CEKF 
P2=P     ;  % to be used by the optimized FULL EKF
P3=P     ;  % to be used by HCEKF

%set of observations. (supposed after linearization)
% here we consider a sequence of 'nObservations' observation of one dimension(only to simplify the example).
% we randomly obtain a set of observation jacobian matrixes and process and observation model noise covariances.

% observation jacobians
H_list  = randn(nObservations,LA) ;
% observation noise covariances
R_list  = abs(randn(nObservations,1)) ;
% process model noise covariances
Q_list  = randn(LA,LA,nObservations) ; 
for n=1:nObservations,                              %make it Possitive Definite 
    Q_list(:,:,n) = Q_list(:,:,n)*Q_list(:,:,n)'/1 ;   
end ;    

% apply the predictions and observations to the reduced system. We consider a sequence of predicion/update
% stages (it is not necessary to be like that)
disp('---------------------------') ;
Printi('number of states           =','[%d]',N)
Printi('number of active states    =','[%d]',LA)
Printi('number of observations\pred=','[%d]',nObservations)

% run compressed filter active component

disp('CEKF begins') ;    
t1 =cputime ;
%flops1 =flops ;
FiMat = eye(LA,LA) ;
PsiMat = zeros(LA,LA) ;
PAA = P(iiActiveStates,iiActiveStates) ;        % reduced system (active states) covariance matrix.

for n=1:nObservations,

    % prediction stage .......................................
    %J=MatrixOneinDiag + dF_list(:,:,n) ;
    %PAA = J*PAA*J' + Q_list(:,:,n) ;
   
  
    PAA = PAA + Q_list(:,:,n) ;
    % compressed auxiliary matrixes, in prediction stage ......
    %  FiMat  = J*FiMat ;  % process model jacobian is the identity matrix in this case. 
    % ......................................................
 
    
    % update stage
    H = H_list(n,:) ;                   % select observaton jacobian

    W = PAA*H' ;
    S = H*W + R_list(n) ;
    iS =inv(S) ;
    % compressed auxiliary matrixes, in update stage ......
    BetaMat = H'*iS*H ;  MuMat = PAA*BetaMat ;
    PsiMat = PsiMat + FiMat'*BetaMat*FiMat ;
    FiMat  = FiMat - MuMat*FiMat ;
    % ....................................
    PAA = PAA - W*iS*W' ;           % reduced system covariance matrix, update it.
    % ....................................
    
end ;    

% ----------------------------------------------------
% --- FULL UPDATE -----------------------------------
% ---- do full update ----
Pab_1 = P(iiActiveStates,iiPassiveStates) ;
P(iiActiveStates,iiActiveStates)=PAA ;
P(iiActiveStates,iiPassiveStates) = FiMat*Pab_1 ;
P(iiPassiveStates,iiActiveStates) = P(iiActiveStates,iiPassiveStates)' ; 
P(iiPassiveStates,iiPassiveStates)=P(iiPassiveStates,iiPassiveStates)- Pab_1'*PsiMat*Pab_1 ;
% ----------------------------------------------------
% ----------------------------------------------------
t2 =cputime ; dt = round((t2-t1)*1000) ;
%flops2 =flops ;
Printi('CEKF end            ,',' dt=[%d]ms',dt);

%dflops =flops2-flops1 ;Printi('flops    ,',' =[%%d]ms',dflops);


% ==============================================================================
% ------------------ Hybrid Compressed ---------------------------------------------------
disp('Hybrid Compressed (HCEKF) begins') ;    
t1 =cputime ;
%flops1 =flops ;

Paa = P3(iiActiveStates,iiActiveStates) ;    
PAA = [ Paa,Paa;Paa,Paa] ; 

iia2 = int16([1:LA]) ;
iia1 = int16([LA+1:2*LA]) ;
Palpha0 = Paa ;
for n=1:nObservations,
    PAA(iia2,iia2) = PAA(iia2,iia2) + Q_list(:,:,n) ;
    % update stage
    H = H_list(n,:) ;                   % select observaton jacobian
    W = PAA(:,iia2)*H' ;
    S = H*W(iia2,:) + R_list(n) ;
    iS =inv(S) ;
    PAA = PAA - W*iS*W' ;           % reduced system covariance matrix, update it.
end ;    

% ----------------------------------------------------
% --- FULL UPDATE -----------------------------------
% ---- do full update ----
Palpha =     PAA(iia1,iia1) ;
iPalfa0 = inv(Palpha0) ;
Mua = P3(iiPassiveStates,iiActiveStates)*iPalfa0 ;
DeltaPalpha = Palpha0 - Palpha ;
P3(iiPassiveStates,iiPassiveStates)=P3(iiPassiveStates,iiPassiveStates)-Mua*DeltaPalpha*Mua' ;
P3(iiActiveStates,iiActiveStates) = PAA(iia2,iia2) ;

P3(iiActiveStates,iiPassiveStates)=PAA(iia2,iia1)*Mua' ;
P3(iiPassiveStates,iiActiveStates)=P3(iiActiveStates,iiPassiveStates)' ; 

% ----------------------------------------------------
t2 =cputime ; dt = round((t2-t1)*1000) ;
Printi('HCEKF       end     ,',' dt=[%d]ms',dt)
% ---------------------------------------------------------------------

% ================= FULL FILTER ================================================

disp('FULL EKF begins') ;    
t1 =cputime ;
%flops1 =flops ;
for n=1:nObservations,

    % P=P+Q, only affect part of the P matrix
    P2(iiActiveStates,iiActiveStates) = P2(iiActiveStates,iiActiveStates) + Q_list(:,:,n) ;
    
 
    % non optimized full EKF (brute force)
    %H =zeros(1,N) ;
    %H(1,iiActiveStates) = H_list(n,:) ;  % select observaton jacobian
    %W = P2*H' ;   S = H*W + R_list(n) ;

    % optimized full EKF
    H = H_list(n,:) ;
    W = P2(:,iiActiveStates)*H' ; S = H*W(iiActiveStates,:)+R_list(n) ;
    
    
    iS =inv(S) ;
    P2 = P2 - W*iS*W' ;           
end ;    
t2 =cputime ; dt = round((t2-t1)*1000) ;
%flops2 =flops ;
Printi('FULL EKF end,        ',' dt=[%d]ms',dt)

%dflops =flops2-flops1 ;Printi('flops    ,',' =[%d]ms',dflops);


% normalize matrixes to have good idea what is going on.
dd  =sqrt(diag(P)) ; P = P./(dd*dd') ; 
dd  =sqrt(diag(P2)) ; P2 = P2./(dd*dd') ; 
dd  =sqrt(diag(P3)) ; P3 = P3./(dd*dd') ; 
clear dd ;


error2 = sum(sum(abs(P2-P))) ;
error3 = sum(sum(abs(P3-P))) ;
disp('..') ;
disp(sprintf('sum absolute errors between both normalized covariance matrixes [error = sum(sum(abs(P_cekf-P_full)))].\nIt is due to numerical error'));
Printi('error_cekf, error_Hcekf=','[%.14f]',[error2,error3]);
Printi('error_cekf, error_Hcekf=','[%e]'   ,[error2,error3]);
% ---------------------------------------------------------------------
disp('---------------------------') ;

figure(1) ;  clf ; colormap('gray') ; image(P*60); title('matrix image') ; 
hold on ; 
plot(iiActiveStates,iiActiveStates,'*y') ; 
hold off ; 


return ;
% ---------------------------------------------------------------------
function Printi(s,frmt,x)
	s1 = sprintf(frmt,x) ;
	disp([s,s1]) ;
return ; 
% ---------------------------------------------------------------------









