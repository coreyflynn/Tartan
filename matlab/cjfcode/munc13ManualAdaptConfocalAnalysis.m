function a=munc13ManualAdaptConfocalAnalysis(path,stack_size,plotflag)
s='smallave';assignin('base','s',s);
check=evalin('base','who(s)');
if isempty(check)==true
    tmpstruct=tiffread2(path,round(stack_size/2));
    tmpim=tmpstruct.data;
    tmpimb=bpass(tmpim,3,20);
    assignin('base','tmpim',tmpim);
    assignin('base','tmpimb',tmpimb);
    figure(1);subplot(2,2,1);imagesc(tmpim);drawnow;
    pointer=impoint(gca,[],[]);
    pointapi=iptgetapi(pointer);
    xlim=get(gca,'XLim');
    ylim=get(gca,'YLim');
    constrainfcn=makeConstrainToRectFcn('impoint',[xlim(1)+21 xlim(2)-21],[ylim(1)+21 ylim(2)-21]);
    pointapi.setDragConstraintFcn(constrainfcn);
    pointapi.addNewPositionCallback(@NewPosCallback);
    smallave=zeros(41);
    for N=1:10
        evalin('base','pause');
        loc=pointapi.getPosition();
        locim=tmpimb(round(loc(2)-20):round(loc(2)+20),round(loc(1)-20):round(loc(1)+20));
        smallave=smallave*(N-1)/N+locim/N;
        figure(1);subplot(2,2,2);imagesc(smallave);drawnow;
        figure(1);subplot(2,2,1);title(sprintf('%d',N));
    end
    assignin('base','smallave',smallave);
else
    smallave=evalin('base','smallave');
end

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
tmpimb=bpass(tmpim,3,20);
tmpxcorr=normxcorr2(smallave,tmpim);
tmpxcorr=tmpxcorr(21:1044,21:1044);
L=bwlabel(tmpxcorr>.5);
stats=regionprops(L);
if plotflag==1
    figure(1);subplot(2,2,1);imagesc(tmpim);title('original image');
    figure(1);subplot(2,2,2);imagesc(tmpimb);title('spatial filter');
    figure(1);subplot(2,2,3);imagesc(tmpxcorr);title('cross correlation');
    figure(1);subplot(2,2,4);imagesc(label2rgb(L,'jet','k','shuffle'));title('found spots');
end
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
    

end%%end main function loop


function NewPosCallback(pos)
tmpim=evalin('base','tmpim');
tmpimb=evalin('base','tmpimb');
figure(1);subplot(2,2,3);imagesc(tmpim(round(pos(2)-20):round(pos(2)+20),round(pos(1)-20):round(pos(1)+20)));
figure(1);subplot(2,2,4);imagesc(tmpimb(round(pos(2)-20):round(pos(2)+20),round(pos(1)-20):round(pos(1)+20)));
end