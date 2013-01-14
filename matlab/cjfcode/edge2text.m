function edge2text(BW,xyres,zres,scale)
%open a file to write to
f=fopen('~/Desktop/vertind3.txt','w');


%trace the edge of the object in each slice
meanY=size(BW,1)/2;
meanX=size(BW,2)/2;
for N=1:size(BW,3)
    try
    B = bwboundaries(BW(:,:,N));
    for j=1:length(B)
    coords=B{j};
    coords1=(coords(:,1)-meanY)*xyres*scale;
    coords2=(coords(:,2)-meanX)*xyres*scale;


    %write each vert to it
    z=N*zres*scale;
    fprintf(f,'[');
    for ii=1:length(coords1)-1
        fprintf(f,sprintf('[%g,%g,%g]',coords2(ii),coords1(ii),z));
        fprintf(f,',');
    end
    fprintf(f,sprintf('[%g,%g,%g]]\n',coords2(ii+1),coords1(ii+1),z));
    end
    end
end


    