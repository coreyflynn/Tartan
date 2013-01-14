omega=2*pi/18;
z=zeros(1024);
s=sprintf('/Volumes/TERABITHIA2/Data 2008/F08_103/Day2/Exp5/mpp files/F06-103_%d',1);
tmp=cpp_read2(s);
s=sprintf('/Volumes/TERABITHIA2/Data 2008/F08_103/Day2/Exp5/mpp files/F06-103_%d',19);
tmp2=cpp_read2(s);
subplot(1,1,1);imagesc(tmp2-tmp);title('select normalization ROI');colormap(gray);
mask=roipoly;
for N=36:500
s=sprintf('/Volumes/TERABITHIA2/Data 2008/F08_103/Day2/Exp5/mpp files/F06-103_%d',N);
tmp=cpp_read2(s);
s=sprintf('/Volumes/TERABITHIA2/Data 2008/F08_103/Day2/Exp5/mpp files/F06-103_%d',N+18);
tmp2=cpp_read2(s);
ratio=mean(tmp2(find(mask==1)))/mean(tmp(find(mask==1)));
oldfrac=(N-1)/N;
z=oldfrac*z+exp(i*omega*N)*(tmp2*ratio-tmp)/N;
imagesc(tmp2*ratio-tmp);drawnow;
if mod(N,36)==0
    subplot(1,2,1);imagesc(angle(z));
    subplot(1,2,2);imagesc(abs(z));drawnow;
end
end
