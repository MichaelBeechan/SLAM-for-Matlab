clear
clc
f0=imread('fr23.png');%读图
figure(1)
imshow(f0)%显示原始图像
f0 = rgb2gray(f0);
f=double(f0);
[g,h]=D3hist(f);%绘制3维直方图
%md=abs(f+g+h)*sqrt(3)/3;
minierror(f);






