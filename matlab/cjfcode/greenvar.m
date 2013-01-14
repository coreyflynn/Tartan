function a=greenvar(endfile)
a.data=zeros(1024,1024,endfile+1);
for i=0:endfile
    s=['/Users/jcrowley/Desktop/greenmovie/Data_E0B' num2str(i) '.BLK'];
    tmp=blkread(s);
    a.data(:,:,i+1)=tmp.data;
    figure(1)
    imagesc(a.data(:,:,i+1));colormap(gray);
    pause(.01);
end
a.var=var(a.data,0,3);
figure(2);imagesc(a.var);
    
    