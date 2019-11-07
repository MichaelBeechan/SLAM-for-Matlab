function [binnov, binnovsig]=proc_innov(innov,innovar,obs,x,u)
%
% function [binnov, binnovsig]=proc_innov(innov,innovar,obs,bnum)
% 
% a function to process innovation results, extracting (optionally)
% innovations for specific beacons and standarad deviations
%



[temp,nsamps]=size(obs);
binnov=zeros(3,nsamps);
binnovsig=zeros(2,nsamps);
j=0;

   	for i=1:nsamps
   	if obs(3,i) ~= 0
      	j=j+1;
         ivec=innov(1:2,i); % innovation
         svec=innovar(1:2,1:2,i); % innovation variance
         angle=x(3,i)+u(2,i); % vehicle heading angle=orientation+steering
         T=[cos(angle) sin(angle); -sin(angle) cos(angle)]; % transform
         tvec=T*ivec;
         tsvec=T*svec*T';
      	binnov(3,j)=obs(4,i);
      	binnovsig(1,j)=sqrt(tsvec(1,1));
         binnovsig(2,j)=sqrt(tsvec(2,2));
         binnov(1:2,j)=tvec;
   	end
	end
binnov=binnov(:,1:j);
binnovsig=binnovsig(:,1:j);
