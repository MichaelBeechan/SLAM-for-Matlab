function [vehicle, ok] = estimate_vehicle_location (H, features, observations),
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function vehicle = estimate_vehicle_location (features, observations, H)
%
% Using an extended Kalman filter, estimate the vehicle location
% for a hypothesis H, which pairs observations with features.
%-------------------------------------------------------
[ok, map] = EKF(features, observations, H);

vehicle.x = map.x(1:3);
vehicle.P = map.P(1:3, 1:3);

%-------------------------------------------------------
function [ok, map] = EKF (features, observations, H)
%-------------------------------------------------------
global calculations;
global chi2;

[vehicle, ok] = mean_square_location (H, features, observations);

map.x = [vehicle.x; features.x];
map.P = [diag([1 1 10*pi/180].^2), zeros(3, size(features.P,2))
    zeros(size(features.P,1), 3), features.P];
map.n = features.n;

xr = map.x(1);
yr = map.x(2);
pr = map.x(3);

Hi = [cos(pr) sin(pr)
     -sin(pr) cos(pr)];

zk = zeros(0,1);
Rk = zeros(0,0);
hk = zeros(0,1);
Hk = zeros(0,0);

for i = 1:length(H)
    if H(i)
        %
        j = H(i);
        ind = point_rows(i);
        
        % measurement i
        zi = observations.z(ind);
        Ri = observations.R(ind, ind);
        
        % linearized measurement equation
        xj = map.x(3 + 2 * j - 1);
        yj = map.x(3 + 2 * j);
        hj = [(xj - xr) * cos(pr) + (yj - yr) * sin(pr)
              (xr - xj) * sin(pr) + (yj - yr) * cos(pr)];
        Hrj = [-cos(pr), -sin(pr), -(xj - xr) * sin(pr) + (yj - yr) * cos(pr)
                sin(pr), -cos(pr),  (xr - xj) * cos(pr) - (yj - yr) * sin(pr)];
        Hij = sparse([Hrj zeros(2, 2 * (i-1)) Hi zeros(2, 2 * (map.n - i))]);
 
        % pile up
        zk = [zk
              zi];
        Rk = blkdiag(Rk, Ri);
        hk = [hk
              hj];
        Hk = [Hk
              Hij];
    end
end

Ck = Hk * map.P * Hk' + Rk;
Kk = map.P * Hk' * inv(Ck);
xk = map.x + Kk * (zk - hk);
Pk = (eye(size(map.P)) - Kk * Hk) * map.P;
map.x = xk;
map.P = Pk;

d2k = mahalanobis2 (zk - hk, Ck);

ok = d2k < chi2(2*nnz(H));

%-------------------------------------------------------
function D2 = mahalanobis2(x, P)
%-------------------------------------------------------

R = chol(P);
y = R'\x;
D2= full(y'*y);