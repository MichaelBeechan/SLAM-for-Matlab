function [g,h]=D3hist(L0)
[r,c]=size(L0);
L1=double(L0);
L2=imnoise(L1,'salt & pepper',0.03);%��ͼ����Ͻ�������
f=imnoise(L2,'gaussian',0.6,1);%��ͼ����Ͼ�ֵΪ������Ϊ1�ĸ�˹����
figure(2)
imshow(f)%��ʾ����������ͼ��

%%%%%%%%%%��˹�˲��õ���ֵg%%%%%%%%%%
gw=fspecial('gaussian');
g=imfilter(f,gw,'replicate');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%��ֵ�˲��õ���ֵh%%%%%%%%%%
h=medfilt2(g);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(3)
surf(f,g,h)