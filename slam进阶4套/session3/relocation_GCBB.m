function H = relocation_GCBB (features, observations)
%-------------------------------------------------------
% To be completed by the SLAM Summer School students
%-------------------------------------------------------
% function H = relocation_GCBB (features, observations)
%
% obtain the pairing hypotesis between observations and
% features, according to the Geometric Constraints
% Branch and Bound algorithm.
%-------------------------------------------------------

% silly answer
H = observations.m:-1:1;
