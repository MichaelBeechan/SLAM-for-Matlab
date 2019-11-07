%% Name£ºMichael Beechan
%% School£ºChongqing University of Technology
%% Time£º2018.12.11
%% Function£ºOptical Flow

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