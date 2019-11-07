%% Name��Michael Beechan
%% School��Chongqing University of Technology
%% Time��2018.12.11
%% Function��Optical Flow

vidReader  = VideoReader('bike.avi');

opticalFlow = opticalFlowLKDoG('NumFrames', 3);

while hasFrame(vidReader)
   frameRGB = readFrame(vidReader);
   frameGray = rgb2gray(frameRGB);
   
   flow = estimateFlow(opticalFlow, frameGray);
   imshow(frameRGB);
   hold on;
   plot(flow, 'DecimationFactor', [5, 5], 'ScaleFactor', 25);
   hold off;
end