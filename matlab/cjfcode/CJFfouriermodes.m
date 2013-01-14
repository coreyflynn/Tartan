function CJFfouriermodes(interval)
for interval=1:90
test=zeros(500,500);
for i=0:interval:180
xscale=cosd(i);
yscale=sind(i);
test(round(250+(100*xscale)),round(250+(100*yscale)))=1;
end
trans0=ifft2(fftshift(test));
test=zeros(500,500);
for i=0:interval:180
xscale=cosd(i);
yscale=sind(i);
test(round(250+(100*xscale)),round(250+(100*yscale)))=1;
end
trans90=ifft2(fftshift(test));
zero=real(trans0(200:300,200:300));
ninty=real(trans90(200:300,200:300));
map=atan2(zero,ninty);
imagesc(map);
pause(.001);
s=['/Users/jcrowley/Desktop/tmp/image' int2str(interval) '.jpg'];
saveas(gca,s);
end