function tmp=cjfangle_mean_estimate_2d_orig(input,omega)
%%only one dimenstional as of yet...
insize=size(input);
z=zeros(insize(1),insize(2));
zimg=zeros(insize(1),insize(2),length(input));
zreal=zeros(insize(1),insize(2),length(input));
for N=1:length(input)
    oldfrac=(N-1)/N;
    z=oldfrac*z+(exp(i*omega*N)*input(:,:,N))/N;
    zimg(:,:,N)=imag(z);
    zreal(:,:,N)=real(z);
    zimagmu=mean(zimg(:,:,N)-mean(zimg(:,:,1:N),3),3);
    %zimagsigma=mean((zimg(N)-mean(zimg(1:N)))^2);
    zrealmu=mean(zreal(:,:,N)-mean(zreal(:,:,1:N),3),3);
    %zrealsigma=mean((zreal(N)-mean(zreal(1:N)))^2);
    s=['N= ' num2str(N)];
    %figure(1);plot(zreal);title(s);
    %figure(2);plot(zimg);title(s);
    figure(3);imagesc(atan2(zimagmu,zrealmu));title(s);colorbar;
    %cjfnormdist2([zrealsigma zimagsigma],[zrealmu zimagmu]);
    pause(.01);
end