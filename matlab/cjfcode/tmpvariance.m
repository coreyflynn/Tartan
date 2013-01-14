%% Copy all the data to binned .mpp files
%for N=325:324+27
 %   s=[stringbase num2str(N) '.BLK'];
 %   disp(sprintf('block %d',N));
 %   tmp=blkread(s);
 %   tmp=abs(mean(tmp.data,3)).*mask;
 %   cpp_write2(sprintf('block%d_av',N),tmp);
%end
%% Save all of the difference images
savepath='/Users/jcrowley/Desktop/F07-249 Variance tmp/';
for N=296:324
orientationdiff=zeros(1024);
directiondiff=zeros(1024);
posone=cpp_read2(sprintf('block%d_av',N));
postwo=cpp_read2(sprintf('block%d_av',N+18));
negone=cpp_read2(sprintf('block%d_av',N+9));
negtwo=cpp_read2(sprintf('block%d_av',N+27));
pos=(posone+postwo)/2;
neg=(negone+negtwo)/2;
ratio=mean(pos(find(mask==1)))/mean(neg(find(mask==1)));
pos=pos*ratio;
diff=pos-neg;
diff=diff-min(min(diff(find(mask==1))));
diff(find(mask==0))=-1;
s=[savepath 'orientation mpp/' num2str(N)];
cpp_write2(s,diff);
imagesc(diff);title(s);colormap(gray);drawnow;
end
%% Calculate the running average of the angle estimate and the variance
omega=2*pi/18;
z.angle=zeros(1024,1024,14);
tmp=zeros(1024);
cycle=0;
for N=36:288
    if mod(N,18)==0
        if cycle>0
            z.angle(:,:,cycle)=angle(tmp);
        end
        cycle=cycle+1;
        tmp=zeros(1024);
    end
    oldfrac=(N-cycle*36)/(N+1-cycle*36);
    diffdata=cpp_read2(num2str(N));
    tmp=tmp*oldfrac+(exp(i*omega*N))*diffdata/(N+1-cycle*36);
    figure(1);imagesc(angle(tmp));drawnow;
end

%% calculate the averge wavelength across all orientaitons
z.wave=zeros(341);
for N=1:18
    oldfrac=(N-1)/N;
    tmp=cpp_read2(sprintf('/Users/jcrowley/Desktop/F07-269 analysis/orientation mpp/F07-269_orientation_local_w.mpp%d',N));
    z.wave=z.wave*oldfrac+tmp/N;
end


