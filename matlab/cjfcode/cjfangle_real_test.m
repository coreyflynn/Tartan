function data=cjfangle_real_test(inputstring,omega)
%%2D version of cjfangle_mean_estimate.m
s=[inputstring num2str(0) '.BLK'];
tmp=blkread(s);
imsize=size(tmp.data(:,:,1));
data.z=zeros(imsize(1),imsize(2));
data.zangle=zeros(imsize(1),imsize(2),21);
data.zmean=zeros(imsize(1),imsize(2),21);
data.zdelta=zeros(imsize(1),imsize(2),21);
cycle=0;
blkpointer=0;
figure;
for N=1:3600
    if mod(N,180)==1
        if cycle>0
            data.zangle(:,:,cycle)=atan2(imag(data.z),real(data.z))*180/pi;
            subplot(2,1,1);imagesc(data.zangle(:,:,cycle));title(N);title ('angle estimate');colorbar;
            subplot(2,1,2);imagesc((data.zdelta(:,:,cycle).^2)*180/pi);title('z Variance');colorbar;
            s=['/Users/jcrowley/Desktop/Wolf code export images/real 2D/' num2str(N) '.jpg'];
            saveas(gca,s);
            drawnow;
        end
        cycle=cycle+1;
    end
    oldfrac=(N-1)/N;
    data.z=oldfrac*data.z+(exp(i*omega*N)*tmp.data(:,:,mod(N,10)+1))/N;
    data.zmean(:,:,cycle)=oldfrac*data.zmean(:,:,cycle)+abs(data.z)/N;
    data.zdelta(:,:,cycle)=oldfrac*data.zdelta(:,:,cycle)+(abs(data.z)-data.zmean(:,:,cycle).^2)/N;
    if mod(N,10)==9
        blkpointer=blkpointer+1;
        s=[inputstring num2str(blkpointer) '.BLK'];
        tmp=blkread(s);
    end
end