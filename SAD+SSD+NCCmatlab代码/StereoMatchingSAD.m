%function StereoMatchingSAD()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function is SAD based Stetere Mathcing algorithm
% Usage Example
%       >>imL=rgb2gray(imread('imL.png'));
%       >>imR=rgb2gray(imread('imR.png'));
%       >>[dispMap_SAD]=StereoMatchingSAD(imL,imR,9,0,52);
%
%          InYeop,Jang(20082044), Dept.of Mechatronics, GIST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [dispMap_SAD]=StereoMatchingSAD(imL, imR, windowSize, dispMin, dispMax)
% Assume the image sizes are same between imgL and imgR 
[wL,hL] = size(imL);
%[wR,hR] = size(imgR);
win=(windowSize-1)/2;
%SAD
for(i=1+win:1:wL-win)
    for(j=1+win:1:hL-win-dispMax)
        preSAD = 1000000;        temp=0.0;        OptimalDisp = dispMin;
        for(dispRange=dispMin:1:dispMax)
            curSAD=0.0;
            for(x=-win:1:win)
                for(y=-win:1:win)
                    if (j+y+dispRange <= hL)
                        temp=imR(i+x,j+y)-imL(i+x,j+y+dispRange);
                        if(temp<0.0)
                            temp=temp*-1.0;
                        end
                        curSAD=curSAD+temp;
                    end
                end
            end
            %Finding a best disaparty
            if (preSAD > curSAD)
                preSAD = curSAD;
                OptimalDisp = dispRange;
            end
        end
        %Final disparity
        dispMap_SAD(i,j) = OptimalDisp;
    end
end