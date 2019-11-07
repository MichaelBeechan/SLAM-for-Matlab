function point = obtain_feature (features, p)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function point = obtain_feature (features, p)
%
% Return the information corresponding to feature p
% in features.
%-------------------------------------------------------

if (p < 0) | (p > features.n)
    error(sprintf('Obtain_feature: feature %d does not exist, map contains %d features!', p, features.n));
end

ind = point_rows (p);
point.x = features.x(ind);
point.P = features.P(ind, ind);
point.radius = features.radius(p);
point.var_radius = features.var_radius(p);
