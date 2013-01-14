function varargout=anglemapbin(im,bin_num)
%This function takes an anglemap defined from 0? to 180? and breaks it into
%an arbitrary number of equaly spaced bins.  The borders of those bins are then
%calculated and a second map of fractures between the bins is optionally reported.
%
%USAGE
%varargout=anglemapbin(im,bin_num)
%
%VARIABLE DEFINITIONS
%im - The image to be binned
%bin_num - The number of bins to split the image into
%varargout - variable output argument
%	if one output is specified, the output is the binned image
%	if two outputs are specified, the first output is the binned image.  The second is
%	the fracture image

%setup a few variables to be used later
imsize=size(im);
bin_size=180/bin_num;
binned_im=zeros(imsize(1),imsize(2),bin_num);
frac=zeros(imsize(1),imsize(2),bin_num);

%For each bin, define an upper and lower bound for the bin.  Next define where in the 
%image values in the bin are found and assign the value of the lower bound to all 
%pixels falling inside the bin.Last, Dilate the edges of the binned image and subtract
%the original.  This highlights the edges of the bin and is used as the basis for the 
%fracture map.
for N=1:bin_num
    upper=N*bin_size;
    lower=N*bin_size-bin_size;
    domain=(((im<upper)-(im>=lower))==0);
    binned_im(:,:,N)=domain*lower;
    frac(:,:,N)=imdilate(imdilate(domain,strel('square',2))-domain,...
        strel('square',4));
end

%sum all of the bins in both the binned image and the fracture map in order to generate
%the final images for both and set them as the output for the function.
if nargout==1
    varargout{1}=sum(binned_im,3);
else
    varargout{1}=sum(binned_im,3);
    varargout{2}=sum(frac,3);
end

%Version: 1.0
%Corey J. Flynn
%Laboratory of Justin Crowley
%Department of Biological Sciences
%Carnegie Mellon University
%Contact: cjflynn@andrew.cmu.edu

        