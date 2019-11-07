%function StereoMatching()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function consits of three methods for stereo matching (SAD,SSD,NCC).
% Usage 
%       1. A input dialog will appear for setting Window Size. Set a
%          number bigger than 2, and click OK button.
%       2. Wait for some seconds. Then, you can see the results of SAD, SSD and
%          NCC stereo mathing in order.
%
%       You can also compare the results by changing window size ! 
%
%          InYeop,Jang(20082044), Dept.of Mechatronics, GIST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function StereoMatching
prompt = {'Enter window size:'};
dlg_title = 'Input for setting window size';
num_lines = 1;
def = {'9'};

answer=inputdlg(prompt,dlg_title,num_lines,def);
winSize = str2double(answer);

if(winSize>2)
    fprintf(1,'Loading Images....\n');
    imL=rgb2gray(imread('imL.png'));
    imL=double(imL);
    imR=rgb2gray(imread('imR.png'));
    imR=double(imR);
    %groundtruth=imread('disp2.pgm');
    %groundtruth=double(groundtruth);
   
    fprintf(1,'Now Processing SAD based Stereo Matching....\n');
    [dispMap_SAD]=StereoMatchingSAD(imL,imR,winSize,0,52);
    dispMap=dispMap_SAD;
    figure('Name','SAD','NumberTitle','off');   imshow(dispMap,[0 52]);
    %fprintf(1,'SAD RMSE : %f\n',sqrt( (mean( dispMap)-groundtruth).^2));
    fprintf(1,'Now Processing SSD based Stereo Matching....\n');
    [dispMap_SSD]=StereoMatchingSSD(imL,imR,winSize,0,52);
    dispMap=dispMap_SSD;
    figure('Name','SSD','NumberTitle','off');   imshow(dispMap,[0 52]);
    
    fprintf(1,'Now Processing NCC based Stereo Matching....\n');
    [dispMap_NCC]=StereoMatchingNCC(imL,imR,winSize,0,52);
    dispMap=dispMap_NCC;
    figure('Name','NCC','NumberTitle','off');   imshow(dispMap,[0 52]);
else
    fprintf(1,'\nYou must set window-size integer bigger than 2!!!!\n');
end