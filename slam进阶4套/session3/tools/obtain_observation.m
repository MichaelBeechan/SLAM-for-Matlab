function point = obtain_observation (observations, p)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function point = obtain_observation (observations, p)
%
% Return the information corresponding to observation p
% in observations.
%-------------------------------------------------------

if (p < 0) | (p > observations.m)
    error(sprintf('Obtain_observation: observation %d does not exist, scan contains %d points!', p, observations.m));
end

ind = point_rows(p);
point.z = observations.z(ind);
point.R = observations.R(ind, ind);
point.radius = observations.radius(p);