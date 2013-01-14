function a=blkanglemap(endfile)
z=zeros(1024);
pos=zeros(1024);
neg=zeros(1024);
for i=11:endfile
    for j=-1:1
        s=['/Volumes/TERABYTHIA/OI data/F07-070/longdaq/CJFLong_E00B' num2str(i+j) '.BLK'];
        tmp=blkread(s);
        pos=pos+tmp.data;
    end
    for j=-1:1
        s=['/Volumes/TERABYTHIA/OI data/F07-070/longdaq/CJFLong_E00B' num2str(i+9+j) '.BLK'];
        tmp=blkread(s);
        neg=neg+tmp.data;
    end
    diff=pos-neg;
    diffmask=-100<diff<100;
    diff=diff.*diffmask;
    figure(1);
    imagesc(diff);colormap(gray);
    ang=10*mod(i,18);
    z=z+(diff*exp(i*2*ang*10));
    figure(2);
    imagesc(real(z));title('magnitude');
    figure(3);
    imagesc(angle(z));title('angle');
    pause(.01);
    pos=zeros(1024);
    neg=zeros(1024);
end
a.mag=abs(z);
a.ang=angle(z);