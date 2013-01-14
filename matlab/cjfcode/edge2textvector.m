function edge2text(BW,xyres,zres)
%open a file to write to
f=fopen('~/Desktop/vertind3.txt','w');


%trace the edge of the object in each slice
for N=1:size(BW,3)
    B = bwboundaries(BW(:,:,N));
    coords=B{1};
    coords1=coords(:,1)*xyres;
    coords2=coords(:,2)*xyres;
    coords1=coords1-mean(coords1);
    coords2=coords2-mean(coords2);

    %write each vert to it
    z=N*zres;
    fprintf(f,'[');
    for ii=1:length(coords1)-1
        fprintf(f,sprintf('Vector(%g,%g,%g)',coords2(ii),coords1(ii),z));
        fprintf(f,',');
    end
    fprintf(f,sprintf('Vector(%g,%g,%g)]\n',coords2(ii+1),coords1(ii+1),z));
end


    