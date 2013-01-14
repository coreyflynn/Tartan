function a=munc13LSManalysis(path,stack_size)
a.centroidsx=[];
a.centroidsy=[];
a.centroidsz=[];
h=waitbar(0,'processing images');
for N=1:stack_size
tmpstruct=tiffread2(path,N);
pause(1);
tmpim=tmpstruct.data;
if ndims(tmpim)==3
    tmpim=rgb2gray(tmpim);
    tmpim=double(tmpim);
else
    tmpim=double(tmpim);
end
subplot(1,3,1);imagesc(tmpim);title('original');drawnow;
flat=medfilt2(bpass(tmpim,5,20));
tmpmean=mean2(flat);
tmpstd=std2(flat);
subplot(1,3,2);imagesc(flat);title('filtered');drawnow;
L=bwlabel(flat>tmpmean+tmpstd*4);
subplot(1,3,3);imagesc(label2rgb(L,'jet','k','shuffle'));title('found spots');drawnow;
stats=regionprops(L);
for i=1:length(stats)
    if stats(i).Area<(pi*10^2)
    a.centroidsx=horzcat(a.centroidsx,stats(i).Centroid(1));
    a.centroidsy=horzcat(a.centroidsy,stats(i).Centroid(2));
    a.centroidsz=horzcat(a.centroidsz,N);
    end
end
waitbar(N/stack_size,h,sprintf('processing images (%d/%d)',N,stack_size));
clear tmpstruct
end
close(h);
a.resultx=a.centroidsx(1);
a.resulty=a.centroidsy(1);
a.resultz=a.centroidsz(1);
h=waitbar(0,'pruning centroid list');
for N=1:length(a.centroidsx)
    eucdist=sqrt((a.resultx-a.centroidsx(N)).^2+(a.resulty-a.centroidsy(N)).^2+(a.resultz-a.centroidsz(N)).^2);
    if min(eucdist)<10
    else
        a.resultx=horzcat(a.resultx,a.centroidsx(N));
        a.resulty=horzcat(a.resulty,a.centroidsy(N));
        a.resultz=horzcat(a.resultz,a.centroidsz(N));
    end
    waitbar(N/length(a.centroidsx),h,sprintf('pruning centroid list (%d/%d)',N,length(a.centroidsx)));
end
a.SliceNumber=stack_size;
a.SliceDensity=length(a.resultx)/stack_size;
close(h);
figure(1);subplot(1,1,1);scatter3(a.resultx,a.resulty,a.resultz);
title(sprintf('found %d points; slice density = %d',length(a.resultx),a.SliceDensity));
    
