%-------------------------------------------------------
% samples from covariance matrix (ignores correlations)
%-------------------------------------------------------
function s = sample( cov, dimensions)

for  dim = 1:dimensions
  s(dim) = sqrt(cov(dim,dim)) * randn(1);
end

s = s';