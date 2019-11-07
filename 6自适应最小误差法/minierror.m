function minierror(f)%最小误差阈值法
Ni=imhist(f);%计算直方图数组
N=sum(Ni);%总像素点个数
errormin=100;%误差最小值
threshold=0;%阈值
P0=0;P1=0;%P0,P1用于存放背景C0和目标C1各自的先验概率
for t=2:255
    u=dot([0:255],Ni/N);%图像的总平均灰度级
    P0=sum(Ni(1:t)/N);%C0类像素所占面积的比例
    P1=1-P0;%C1类像素所占面积的比例
    if P0==0|P0==1
        continue
    end
    u0=dot([0:t-1],Ni(1:t)/N)/P0;%C0类像素的平均灰度
    u1=dot([t:255],Ni(t+1:256)/N)/P1;%C1类像素的平均灰度
    for i=0:t-1
        k0(i+1)=(i-u0)^2;
    end
    det0=dot(k0(1:t),Ni(1:t)/N)/P0;%C0类的方差
    for i=t:255
        k1(i-t+1)=(i-u1)^2;
    end
    det1=dot(k1(1:256-t),Ni(t+1:256)/N)/P1;%C1类的方差
    
    J(t)=P0*log10((det0+0.0001)/(P0^2))+P1*log10((det1+0.0001)/(P1^2));%误差公式
     %求出误差的最小值，最小时的那个值对应的t值存入errormin
    if J(t)<errormin
        errormin=J(t);
        threshold=t-1;
    end 
end

BW1=im2bw(f,threshold/255);%阈值分割
figure(4)
imshow(BW1)