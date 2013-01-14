function [out,thresh]=MCTstack(in)
out=in*0;
thresh=[];
for N=1:size(in,3)
    m=MCT(in(:,:,N));
    out(:,:,N)=m.image;
    thresh=horzcat(thresh,m.tv);
end
thresh=mean(thresh);