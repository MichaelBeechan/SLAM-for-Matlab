function h = draw_ellipse(pos, cov, color)
%-------------------------------------------------------
% University of Zaragoza
% Centro Politecnico Superior
% Robotics and Real Time Group
% Authors:  J. Neira, J. Tardos
% Date   :  7-2002
%-------------------------------------------------------
% function h = draw_ellipse(pos, cov, color)
%
% draws an ellipse, centered at pos, corresponding to
% the confidence region determined by cov, given chi2(2)
%-------------------------------------------------------
global chi2;

persistent CIRCLE

if isempty(CIRCLE) 
    tita = linspace(0, 2*pi,20);
    CIRCLE = [cos(tita); sin(tita)];
end

[V,D]=eig(full(cov(1:2,1:2)));
ejes=sqrt(chi2(2)*diag(D));
P = (V*diag(ejes))*CIRCLE;
hp = line(P(1,:)+pos(1), P(2,:)+pos(2));
set(hp,'Color', color);
set(hp,'LineStyle', ':');
