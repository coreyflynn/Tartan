function a=munc13SliceAnalysis(im)
subplot(1,1,1);imagesc(im);
[cx,cy,c,x,y]=improfile;
imangle=(tan((y(1)-y(2))/(x(1)-x(2))))/pi*180;
im=imrotate(im,imangle);
subplot(1,1,1);imagesc(im);title('crop this image');
mask=roipoly;
im=double(im);
[ylist,xlist]=find(mask==1);
xlength=max(xlist)-min(xlist);
ylength=max(ylist)-min(ylist);
immeanx=zeros(1,xlength);
imsemx=zeros(1,xlength);
immeany=zeros(1,ylength);
imsemy=zeros(1,ylength);
for N=1:xlength
    pointer=min(xlist)+N-1;
    imslice=im(:,pointer);
    immeanx(N)=mean(imslice(mask(:,pointer)==1));
    imsemx(N)=std(imslice(mask(:,pointer)))/sqrt(sum(mask(:,pointer)));
    subplot(1,2,1);plot(immeanx(1:N));hold on;plot(immeanx(1:N)+imsemx(1:N),'r');plot(immeanx(1:N)-imsemx(1:N),'r');
    title('Anterior-Posterior');drawnow;
    hold off;
end

for N=1:ylength
    pointer=min(ylist)+N-1;
    imslice=im(pointer,:);
    immeany(N)=mean(imslice(mask(pointer,:)==1));
    imsemy(N)=std(imslice(mask(pointer,:)))/sqrt(sum(mask(pointer,:)));
    subplot(1,2,2);plot(immeany(1:N));hold on;plot(immeany(1:N)+imsemy(1:N),'r');plot(immeany(1:N)-imsemy(1:N),'r');
    title('Medial-Lateral');drawnow;
    hold off;
end

a.APmean=immeanx;
a.APsem=imsemx;
a.MLmean=immeany;
a.MLsem=imsemy;
