function draw_radius (x, y, r, color)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function draw_radius (x, y, r, color)
%
% Draw a circle depicting the area of a point feature
% with radius r.
%-------------------------------------------------------

for p = 1:length(x),
    xr = x(p) - r(p)/2;
    yr = y(p) - r(p)/2;
    wr = r(p);
    hr = r(p);
    if (wr > 0) & (hr > 0)
        rectangle('Curvature', [1 1], 'Position', [xr yr wr hr], 'EdgeColor', color);
    end
end
