z=zeros(1024);
figure;
for j=36:72
    s=['/shared files/F07-249 longdaq/longdaq/Data_E0B' num2str(j) '.blk'];
    zero1=blkread(s);
    %s=['/shared files/F07-249 longdaq/longdaq/Data_E0B' num2str(j+18) '.blk'];
    %zero2=blkread(s);
    s=['/shared files/F07-249 longdaq/longdaq/Data_E0B' num2str(j+9) '.blk'];
    ninety1=blkread(s);
    %s=['/shared files/F07-249 longdaq/longdaq/Data_E0B' num2str(j+27) '.blk'];
    %ninety2=blkread(s);
    zmean=mean(zero1.data,3);
    nmean=mean(ninety1.data,3);
    diff=medfilt2(nmean-zmean);
    subplot(1,3,1);imagesc(diff);colormap(gray);title('current difference image');
    z=z+diff*2.*exp(i*2*((j-38)*pi/180));
    subplot(1,3,2);imagesc(imag(log((z))));title('phase')
    subplot(1,3,3);imagesc(abs(z));colormap(gray); title('magnitude')
    pause(.01);
    s=['/Users/jcrowley/Desktop/tmp/F07-249' num2str(i) '.jpg'];
    saveas(gca,s);
end