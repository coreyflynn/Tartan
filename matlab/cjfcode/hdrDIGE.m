function hdr=hdrDIGE(ims,thresh)
for ii=1:size(ims,1)
    for jj=1:size(ims,2)
        if ims(ii,jj,1)>=thresh
            expTime= [15 1];
            vals=ims(ii,jj,2:3);
            vals=reshape(vals,[1 2]);
            pp=interp1(expTime,vals,'linear','pp');
            newval=ppval(pp,60);
            ims(ii,jj,1)=newval;
            %disp(sprintf('y=%g,x=%g',ii,jj));
        end
    end
end
hdr=ims(:,:,1);
            