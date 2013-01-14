function threshIm = blockTheshold(im,blocksize,minVal)
% blockThreshold
%
% AUTHOR(S): Corey Flynn
% Data Created: February 22, 2011
% Last Modified: April 28, 2011
%
% PURPOSE:
% compute the theshold of an input image by breaking the image into NxN pixel blocks where N
% is the user specified block size and determining the appropriate threshold for each block 
% individually
%
% INPUT(S):
% im: The image to be thresholded
% blocksize: the size in pixels of the bloc to use
% minVal: The minimum pixel value in a block that is allowed to be a positive pixel in the
% 		  thresholded image.  This is analogous to a global threshold
%
% OUTPUT(S):
% threshIm: The block thresholded image
%
% EXAMPLE USAGE:
% threshIm = blockThreshold(im,32,50);
% This usesage will produce a 32x32 block thresholded binary verion (threshIm) of im in which all 
% positive pixels have a minimum value of 50 in the image im.
%
% NOTES:
% This algorithm makes use of Krishnan Padmanabhan's maximum correlation threshold 
% approach for the implimentation of each block's threshold

%initialize a small 32x32 image to hold the current block's image as well as one to store the 
%final result
currentBlock=zeros(blocksize);
threshIm=im*0;

%raster left to right, top to bottom through the image and threshold each block
for ii = 1:blocksize:size(im,1)
	for jj = 1:blocksize:size(im,2)
		try
			currentBlock = im(ii:ii+blocksize-1,jj:jj+blocksize-1);
			if max(currentBlock(:))>minVal
				MCTdata = MCT(currentBlock);
				threshIm(ii:ii+31,jj:jj+31) = MCTdata.image;
			end
		end
	end
end