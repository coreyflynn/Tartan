function a=angularVarianceAnalysis(zcomplex)
%separate phase and mag info
mags=zeros(size(zcomplex));
angs=zeros(size(zcomplex));
for N=1:8
    mags(:,:,N)=abs(zcomplex);
    angs(:,:,N)=abs(zcomplex);
end

%calculate phase mean and standard deviation maps
a.angMean=circ_mean(angs);
a.angStd=circ_std(angs);

%calculate magnitude mean and standard deviation maps
a.magMean=mean(mags,3);
a.magStd=std(mags,0,3);

%find putative pinwheel centers and compute pinwheel distance map
[bin_im,frac]=anglemapbin(angMean,4);
a.pwDist=bwdist(frac>2);


function bi=imageBinRef(im,low,high,mask)
%return a binary image of locations in which the positive pixels are inside
%of the user defined mask, above the low cutoff and below the high cutoff
im(find(im<low))=0;
im(find(im>high))=0;
im=im.*mask;
bi=im>0;