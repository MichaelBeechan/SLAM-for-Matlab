%function StereoMatchingNCC()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function is NCC based Stetere Mathcing algorithm
% Usage Example
%       >>imL=rgb2gray(imread('imL.png'));
%       >>imR=rgb2gray(imread('imR.png'));
%       >>[dispMap_NCC]=StereoMatchingNCC(imL,imR,9,0,52);
%
%          InYeop,Jang(20082044), Dept.of Mechatronics, GIST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dispMap_NCC]=StereoMatchingNCC(imL, imR, windowSize, dispMin, dispMax)
% Assume the image sizes are same between imgL and imgR 
[wL,hL] = size(imL);
%[wR,hR] = size(imgR);
win=(windowSize-1)/2;
%NCC
for(i=1+win:1:wL-win)
    for(j=1+win:1:hL-win-dispMax)
        preNCC = 0.0;
        OptimalDisp = dispMin;
        for(dispRange=dispMin:1:dispMax)
            curNCC=0.0; NCCNumerator=0.0; NCCDenominator=0.0; NCCDenominatorRightWindow=0.0; NCCDenominatorLeftWindow=0.0;
            for(x=-win:1:win)
                for(y=-win:1:win)
                   NCCNumerator=NCCNumerator+(imR(i+x,j+y)*imL(i+x,j+y+dispRange));
                   NCCDenominatorRightWindow=NCCDenominatorRightWindow+(imR(i+x,j+y)*imR(i+x,j+y));
                   NCCDenominatorLeftWindow=NCCDenominatorLeftWindow+(imL(i+x,j+y+dispRange)*imL(i+x,j+y+dispRange));
                end
            end
            NCCDenominator=sqrt(NCCDenominatorRightWindow*NCCDenominatorLeftWindow);
            curNCC=NCCNumerator/NCCDenominator;
            if (preNCC < curNCC)
                preNCC = curNCC;
                OptimalDisp = dispRange;
            end
        end
        dispMap_NCC(i,j) = OptimalDisp;
    end
end