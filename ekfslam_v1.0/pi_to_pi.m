function angle = pi_to_pi(angle)  % ���ڽ��Ƕ�ת����-pi��+pi�ķ�Χ��

%function angle = pi_to_pi(angle)
% Input: array of angles.
% Tim Bailey 2000

angle = mod(angle, 2*pi);

i=find(angle>pi);
angle(i)=angle(i)-2*pi;

i=find(angle<-pi);
angle(i)=angle(i)+2*pi;
