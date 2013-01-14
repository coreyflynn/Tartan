function clipped_display(input_axis,data,clip_val)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    This function is used to draw a matix into the specified axis.  The 
%    clipping value of the image as displayed is set at the user specified 
%    clip val.  clip_val_edit is the number of standard deviations from the mean
%    at which we will set the black and white values of the image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
input_axis;imagesc(data);colormap(gray);
tmpmean=mean2(data(410:610,410:610));
tmpstd=std2(data(410:610,410:610));
caxis([tmpmean-clip_val*tmpstd tmpmean+clip_val*tmpstd]);drawnow;

title(sprintf('mean=%g min/max=%g/%g',tmpmean,tmpmean-clip_val*tmpstd,tmpmean+clip_val*tmpstd));