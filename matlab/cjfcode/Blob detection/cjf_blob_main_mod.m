function [i,j,p]=cjf_blob_main_mod(InputImage,MaskImage)
% This is a demo of the code used for the experiments in cell counting

%clear all;

%InputImage = imread('TOPRO.cat.N.s1.tif'); 
%MaskImage  = imread('TOPRO.cat.N.s1_mask.tif');

%p = blobdetector(InputImage, 10, 5, 0, 0, MaskImage);

%InputImage = imread('Series003_Median001   12_f_s39.jpg'); 
%%%%%%%%%%%CJF EDIT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GreyImage  = (InputImage(:,:,1)+InputImage(:,:,2)+InputImage(:,:,3))/3;
%MaskImage= InputImage>mean2(InputImage(MaskImage))+std2(InputImage(MaskImage));
figure;imagesc(MaskImage);drawnow;
%figure; imshow(MaskImage);
[i,j,p] = cjfblobdetector(InputImage, 70, 8, 0, 0, MaskImage);


%InputImage = imread('Test.jpg'); 
%GreyImage  = InputImage(:,:,3); %in a blue color
%BinaryImage= GreyImage>60;
%MaskImage = BinaryImage;
%figure; imshow(MaskImage);
%p = blobdetector(InputImage, 30, 20, 0, 0, MaskImage);