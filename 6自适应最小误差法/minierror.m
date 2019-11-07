function minierror(f)%��С�����ֵ��
Ni=imhist(f);%����ֱ��ͼ����
N=sum(Ni);%�����ص����
errormin=100;%�����Сֵ
threshold=0;%��ֵ
P0=0;P1=0;%P0,P1���ڴ�ű���C0��Ŀ��C1���Ե��������
for t=2:255
    u=dot([0:255],Ni/N);%ͼ�����ƽ���Ҷȼ�
    P0=sum(Ni(1:t)/N);%C0��������ռ����ı���
    P1=1-P0;%C1��������ռ����ı���
    if P0==0|P0==1
        continue
    end
    u0=dot([0:t-1],Ni(1:t)/N)/P0;%C0�����ص�ƽ���Ҷ�
    u1=dot([t:255],Ni(t+1:256)/N)/P1;%C1�����ص�ƽ���Ҷ�
    for i=0:t-1
        k0(i+1)=(i-u0)^2;
    end
    det0=dot(k0(1:t),Ni(1:t)/N)/P0;%C0��ķ���
    for i=t:255
        k1(i-t+1)=(i-u1)^2;
    end
    det1=dot(k1(1:256-t),Ni(t+1:256)/N)/P1;%C1��ķ���
    
    J(t)=P0*log10((det0+0.0001)/(P0^2))+P1*log10((det1+0.0001)/(P1^2));%��ʽ
     %���������Сֵ����Сʱ���Ǹ�ֵ��Ӧ��tֵ����errormin
    if J(t)<errormin
        errormin=J(t);
        threshold=t-1;
    end 
end

BW1=im2bw(f,threshold/255);%��ֵ�ָ�
figure(4)
imshow(BW1)