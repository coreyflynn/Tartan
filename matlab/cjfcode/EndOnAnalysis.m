function out=EndOnAnalysis(imstack)
imstack=double(imstack);
confirm=0;
while confirm==0
[counter,centerx,centery,x,y,mag]=draw_grid(imstack);
userans=questdlg('Process using this Grid?');
if strcmp(userans,'No')==1
    confirm=0;
else
    confirm=1;
end
end
figure(2);
imsize=size(imstack);
domainim=zeros(imsize(1),imsize(2));
for N=1:counter
    mask=roipoly(domainim,[centerx x(N) x(mod(N,counter)+1)],[centery y(N) y(mod(N,counter)+1)]);
    domainim(mask==1)=N;
end
subplot(1,3,1);imagesc(domainim);title('Domains');
out=zeros(100,233,counter);
bar=waitbar(0,'Progess');
counter2=0;
counter3=0;
for i=0:2*pi/10:2*pi
    counter3=counter3+1;
for j=1:1
        tmpim=imstack(:,:,j);
        subplot(1,3,2);imagesc(tmpim.*(domainim==counter3));title(sprintf('grabbing data from image %d',j));drawnow;
for N=1:100
    [maskx(1),masky(1)]=pol2cart(i,mag*N/100);
    [maskx(2),masky(2)]=pol2cart(i,mag*(N+1)/100);
    [maskx(4),masky(4)]=pol2cart(i+2*pi/10,mag*N/100);
    [maskx(3),masky(3)]=pol2cart(i+2*pi/10,mag*(N+1)/100);
    maskx=maskx+centerx;
    masky=masky+centery;
    mask=roipoly(domainim,maskx,masky);
    out(N,j,counter3)=mean2(tmpim(mask==1));
    counter2=counter2+1;
    waitbar((counter2)/(counter*233*100),bar,sprintf('Prgress (%d/%d)',(counter2),(counter*233*100)));
end
subplot(1,3,3);imagesc(out(:,:,counter3));colormap(gray);title(sprintf('Current analysis of wedge #%d',counter3));drawnow;
end
end
close(bar);

function [counter,centerx,centery,x,y,mag]=draw_grid(imstack)
figure(1);imagesc(imstack(:,:,1));colormap(gray);truesize;
title('Select Center Point');
[centerx,centery]=ginput(1);
title('select edge distance');
[edgex,edgey]=ginput(1);
mag=sqrt((edgex-centerx)^2+(edgey-centery)^2);
counter=0;
figure(1);imagesc(imstack(:,:,1));colormap(gray);title('Analysis Grid');
for N=0:2*pi/10:2*pi
    counter=counter+1;
    [x(counter),y(counter)]=pol2cart(N,mag);
    x(counter)=x(counter)+centerx;
    y(counter)=y(counter)+centery;
    line([centerx x(counter)],[centery y(counter)],'Color','w');
end
for N=1:counter
    line([x(N) x(mod(N,counter)+1)],[y(N) y(mod(N,counter)+1)],'Color','w');
end