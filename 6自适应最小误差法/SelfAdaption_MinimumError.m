clear
clc
f0=imread('fr23.png');%��ͼ
figure(1)
imshow(f0)%��ʾԭʼͼ��
f0 = rgb2gray(f0);
f=double(f0);
[g,h]=D3hist(f);%����3άֱ��ͼ
%md=abs(f+g+h)*sqrt(3)/3;
minierror(f);






