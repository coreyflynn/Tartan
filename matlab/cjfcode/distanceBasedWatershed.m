function [Distance,Labels] = distanceBasedWatershed(im,flag)

%image= a binary image to compute the distance and watershed from
%flag= 0 if the forground is dark, 1 if it is light

%compliment the image if necessary
if flag == 1
	im=~im;
end

%set up the distance image for segmentation
Distance = bwdist(im);
Distance = -Distance;
DistanceInf = Distance;
DistanceInf(im) = -Inf;

%segment using a watershed transform
Labels = watershed(DistanceInf,8);