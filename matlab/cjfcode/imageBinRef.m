function bi=imageBinRef(im,low,high,mask)
%return a binary image of locations in which the positive pixels are inside
%of the user defined mask, above the low cutoff and below the high cutoff
im(find(im<low))=0;
im(find(im>high))=0;
im=im.*mask;
bi=im>0;