function [YH YL] = Training_LH(upscale,nTraining)
%%% construct the HR and LR training pairs from the FEI face database
disp('Constructing the HR-LR training set...');
for i=1:nTraining
    %%% read the HR face images from the HR training set
    strh = strcat('.\trainingFaces\',num2str(i),'.bmp');    
    HI = imread(strh); 
    YH(:,:,i) = HI;
    
    %%% generate the LR face image by smooth and down-sampling
    LI = imresize(HI,1/upscale,'bicubic');
    LI = imresize(LI,upscale,'bicubic');
    YL(:,:,i) = LI;
%     strL = strcat('.\trainingFaces\',num2str(i),'_l.jpg');
%     imwrite(uint8(LI),strL,'jpg'); 
end

disp('done.');