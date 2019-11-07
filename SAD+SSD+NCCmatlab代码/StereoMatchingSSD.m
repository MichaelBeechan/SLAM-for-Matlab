%function StereoMatchingSSD()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function is SSD based Stetere Mathcing algorithm
% Usage Example
%       >>imL=rgb2gray(imread('imL.png'));
%       >>imR=rgb2gray(imread('imR.png'));
%       >>[dispMap_SSD]=StereoMatchingSSD(imL,imR,9,0,52);
%
%          InYeop,Jang(20082044), Dept.of Mechatronics, GIST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [dispMap_SSD]=StereoMatchingSSD(imL, imR, windowSize, dispMin, dispMax)
% Assume the image sizes are same between imgL and imgR 
[wL,hL] = size(imL);
%[wR,hR] = size(imgR);
win=(windowSize-1)/2;
%SSD
for(i=1+win:1:wL-win)
    for(j=1+win:1:hL-win-dispMax)
        preSSD = 100000;        temp=0.0;        OptimalDisp = dispMin;
        for(dispRange=dispMin:1:dispMax)
            curSSD=0.0;
            for(x=-win:1:win)
                for(y=-win:1:win)
                    if (j+y+dispRange <= hL)
                        temp=imR(i+x,j+y)-imL(i+x,j+y+dispRange);
                        temp=temp*temp;
                        curSSD=curSSD+temp;
                    end
                end
            end
            if (preSSD > curSSD)
                preSSD = curSSD;
                OptimalDisp = dispRange;
            end
        end
        dispMap_SSD(i,j) = OptimalDisp;
    end
end