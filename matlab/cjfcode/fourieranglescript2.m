xmag=zeros(1024);
ymag=zeros(1024);
z=zeros(1024);
figure(4);
for N=1:18
s=sprintf('image%d.jpg',N);
tmp=double(imread(s));
z=z*(N-1/N)+tmp*exp(i*2*pi/18*N)/N;
%imagesc(angle(z)/pi*180+90);colorbar;
imagesc(tmp);colormap(gray);colorbar;
%colormap(cmaps.cjflut.circle);
drawnow;
end
%invert=find(z<0);
%z(invert)=180+z(invert);
%imagesc(z);colorbar;