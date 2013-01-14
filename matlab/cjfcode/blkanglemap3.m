zmag=zeros(1024);
zang=zeros(1024);
for j=36:334
    s=['/shared files/F07-249 longdaq/longdaq/Data_E0B' num2str(j) '.blk'];
    zero1=blkread(s);
    s=['/shared files/F07-249 longdaq/longdaq/Data_E0B' num2str(j+9) '.blk'];
    ninety1=blkread(s);
    zmean=mean(zero1.data,3);
    nmean=mean(ninety1.data,3);
    %diff=medfilt2(nmean-zmean);
    diff=nmean-zmean;
    diff=diff-mean2(diff);
    figure(1);imagesc(diff);colormap(gray);title('current difference image');
    updatelocs=find(diff>zmag);
    zmag(updatelocs)=diff(updatelocs);
    zang(updatelocs)=mod(j,18)*10;
    figure(2);imagesc(zang);colorbar;caxis([0 180]);title(mod(j,18)*10)
    figure(3);imagesc(zmag);
    pause(.01);
    s=['/Users/jcrowley/Desktop/anglemaps/ang_median/F07-249' num2str(j) '.jpg'];
    saveas(figure(2),s);
end