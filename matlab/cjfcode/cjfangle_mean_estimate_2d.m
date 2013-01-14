function data=cjfangle_mean_estimate_2d(input,omega)
%%2D version of cjfangle_mean_estimate.m
imsize=size(input(:,:,1));
data.z=zeros(imsize(1),imsize(2),21);
data.zangle=zeros(imsize(1),imsize(2),21);
data.zmean=zeros(imsize(1),imsize(2),21);
data.zdelta=zeros(imsize(1),imsize(2));
cycle=0;
for N=1:360
    if mod(N,18)==1
        if cycle>0
            data.zangle(:,:,cycle)=angle(data.z(:,:,cycle))*180/pi;
            tmp.angle=data.zangle(:,:,1:cycle);
            subplot(2,1,1);imagesc(mean(tmp.angle,3));title(N);title ('angle estimate');colorbar;
            data.zdelta=std(tmp.angle,1,3);
            subplot(2,1,2);imagesc((data.zdelta(:,:))*180/pi);title('angle Variance');colorbar;        
            drawnow;
        end
        cycle=cycle+1;
    end
    oldfrac=(N-1)/N;
    data.z(:,:,cycle)=oldfrac*data.z(:,:,cycle)+(exp(i*omega*N)*input(:,:,N))/N;
    %data.zmean(:,:,cycle)=oldfrac*data.zmean(:,:,cycle)+abs(data.z)/N;
    %data.zdelta(:,:,cycle)=oldfrac*data.zdelta(:,:,cycle)+(abs(data.z)-data.zmean(:,:,cycle).^2)/N;
end