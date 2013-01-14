xmag=zeros(1024);
ymag=zeros(1024);
z=zeros(1024);
figure(4);
for N=1:18
s=['/Volumes/TERABITHIA2/Data 2008/F08_103/Day2/Analysis/diffs/F08_103_orientation' num2str(N)];
tmp=cpp_read2(s);
%imagesc(tmp);colorbar;
xmag=xmag+tmp*cosd(20*N);
ymag=ymag+tmp*sind(20*N);
z=atan2(ymag,xmag)/2;
z=z/pi*180+90;
imagesc(z);colormap(gray);colorbar;title('angle');

colormap(cmaps.cjflut.circle);
drawnow;
end
%invert=find(z<0);
%z(invert)=180+z(invert);
%imagesc(z);colorbar;