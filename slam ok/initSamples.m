function [samples, weight] = initSamples(numSamples, mean, cov)

stateDim = size(mean,1);

samples = repmat( mean, 1, numSamples);
for s = 1:numSamples
  samples(:,s) = sample( cov, stateDim) + mean;
  weight(s) = 1.0;
end

