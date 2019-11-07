function result = transform_observations (observations, vehicle)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function result = transform_observations (observations, vehicle)
%
% Transform observations in the vehicle reference to
% absolute coordinates, given vehicle.x location.
%-------------------------------------------------------

result = observations;

%first transform to global reference
twr = vehicle.x;
trp = reshape([reshape(observations.z, 2, observations.m); zeros(1, observations.m)], observations.m * 3, 1);
twp = tcompv (twr, trp);

% transform state vector
z = reshape(twp, 3, observations.m);
z = z(1:2,:);
result.z = reshape (z, observations.m * 2, 1);

% transform covariance
J1 = sparse(zeros(0,0));
J2 = sparse(zeros(0,0));

for i=1:observations.m,  
    j1 = jacobian1(twr, trp(3*i - 2: 3*i));
    j2 = jacobian2(twr, trp(3*i - 2: 3*i));
    J1 = [J1
         sparse(j1)];
    J2 = blkdiag(J2, sparse(j2(1:2,1:2)));
end

M = J1 * vehicle.P * J1';
ind = sort ([1:3:(3*observations.m), 2:3:(3*observations.m)]);

result.R = M(ind, ind) + J2 * observations.R * J2';
