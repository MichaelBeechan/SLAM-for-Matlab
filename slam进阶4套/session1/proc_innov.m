function [binnov, binnovsig]=proc_innov(innov,innovar,obs,bnum)
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

if nargin==4
	for i=1:nsamps
   	if obs(3,i) == bnum
      	j=j+1;
      	binnov(1:2,j)=innov(:,i);
      	binnov(3,j)=obs(4,i);
      	binnovsig(1,j)=sqrt(innovar(1,1,i));
      	binnovsig(2,j)=sqrt(innovar(2,2,i));
   	end
	end
else
   	for i=1:nsamps
   	if obs(3,i) ~= 0
      	j=j+1;
      	binnov(1:2,j)=innov(:,i);
      	binnov(3,j)=obs(4,i);
      	binnovsig(1,j)=sqrt(innovar(1,1,i));
      	binnovsig(2,j)=sqrt(innovar(2,2,i));
   	end
	end
end
binnov=binnov(:,1:j);
binnovsig=binnovsig(:,1:j);
