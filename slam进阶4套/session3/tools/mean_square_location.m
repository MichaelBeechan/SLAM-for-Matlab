function [vehicle, ok] = mean_square_location (H, features, observations)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function [t, err] = mean_square_location (H, features, observations)
%
% Given a pairing hypothesis H between observations and
% features, determine the vehicle location that minimizes
% the mean square error between the paired observations
% and features
%-------------------------------------------------------

Eh = find(H); % paired observations
Fh = H(Eh);   % paired features
n = length(Eh);

Eh = [observations.z(2*Eh - 1) observations.z(2*Eh)];
Fh = [features.x(2*Fh - 1) features.x(2*Fh)];

Fx = mean(Fh(:, 1));
Fy = mean(Fh(:, 2));
Ex = mean(Eh(:, 1));
Ey = mean(Eh(:, 2));

xip = Fh(:, 1) - Fx;
yip = Fh(:, 2) - Fy;
uip = Eh(:, 1) - Ex;
vip = Eh(:, 2) - Ey;

A = sum(xip.^2 + yip.^2);
B = sum(uip.^2 + vip.^2);
C = sum(xip.*uip + yip.*vip);
S = sum(yip.*uip - xip.*vip);
E = A - 2*sqrt(S^2 + C^2) + B;

% mean square error
err = sqrt(E/n);

% consistent if error less than 1m.
ok = err <= 1;

% vehicle location that minimizes mean square error
Ft = atan2(S, C);
Xfcf = [Fx; Fy; Ft];

Et = 0;
Xece = [Ex; Ey; Et];

Xfe = tcomp(Xfcf, tinv (Xece));

t = Xfe;

vehicle.x = t;
vehicle.P = zeros(3,3);