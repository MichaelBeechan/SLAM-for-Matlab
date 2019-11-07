function cov = rotcov(cov, theta)
% ROTCOV
% function cov = rotcov(cov, theta)

a = cos(theta);
b = -sin(theta);
ab = a * b;
asq = a*a;
bsq = b*b;
e = cov(1,1);
f = cov(1,2);
h = cov(2,2);

xx = asq * e + 2 * ab * f + bsq * h;
xy = ab * (h - e) + f * (asq - bsq);
yy = bsq * e - 2 * ab * f + asq * h;

cov = [    xx  xy  ; 
           xy  yy  ];