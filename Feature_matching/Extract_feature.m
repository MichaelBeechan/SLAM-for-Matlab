%% Name£ºMichael Beechan
%% School£ºChongqing University of Technology
%% Time£º2018.12.11
%% Function£ºExtract image features

%% read image
boxImage = imread('1.jpg');
boxImage = rgb2gray(boxImage);
%{
figure;
imshow(boxImage);
title('Image of a box');
%}
sceneImage = imread('2.jpg');
sceneImage = rgb2gray(sceneImage);
%{
figure;
imshow(sceneImage);
title('Image of cluttered scene');
%}
%% detect image feature points
boxPoints = detectORBFeatures(boxImage);
scenePoints = detectORBFeatures(sceneImage);
figure(1);
imshow(boxImage);
title('100 Feature Points');
hold on;
plot(selectStrongest(boxPoints, 100));

figure(2);
imshow(sceneImage);
title('300 Feature Points');
hold on;
plot(selectStrongest(scenePoints, 300));

%% Extract feature descriptor
[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

%% find Putative point matches
boxPairs = matchFeatures(boxFeatures, sceneFeatures);

%% display matched features
matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure(3);
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, matchedScenePoints, 'montage');
title('Putatively Matched Points(Including Outliers)');

%% Locate the Object in Scene Using Putative Matches
[tform, inlierBoxPoints, inlierScenePoints] = ...
    estimateGeometricTransform(matchedBoxPoints, matchedScenePoints, 'affine');
figure(4);
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, inlierScenePoints, 'montage');
title('Matched Points(Inliers Only)');

%% Get the bounding polygon£¨¶à±ßÐÎ£©of the reference image
boxPolygon = [1, 1;...                              %top-left
        size(boxImage, 2), 1;...                    %top-right
        size(boxImage, 2), size(boxImage, 1);...    %bottom-right
        1, size(boxImage, 1);...                    %bottom-left
        1, 1];                                      %top-left again to close the polygon
%% Transform the polygon into the coordinate system of the target image
%% The transformed polygon indicates the location of the object in scene
newBoxPolygon = transformPointsForward(tform, boxPolygon);
figure(5);
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');

