function [g,h]=D3hist(L0)
[r,c]=size(L0);
L1=double(L0);
L2=imnoise(L1,'salt & pepper',0.03);%给图像加上椒盐噪声
f=imnoise(L2,'gaussian',0.6,1);%给图像加上均值为，方差为1的高斯噪声
figure(2)
imshow(f)%显示加上噪声的图像

%%%%%%%%%%高斯滤波得到均值g%%%%%%%%%%
gw=fspecial('gaussian');
g=imfilter(f,gw,'replicate');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%中值滤波得到中值h%%%%%%%%%%
h=medfilt2(g);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
surf(f,g,h)