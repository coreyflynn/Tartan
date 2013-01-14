function cjfangle_mean_estimate(input,omega)
%%only one dimenstional as of yet...
z=0;
zimg=0;
zreal=0;
tmp=zeros(1,length(input));
tmp2=zeros(1,length(input));
magtmp=0;
angtmp=0;
zdelta=0;
zmean=0;
figure(7);
for N=1:length(input)
    oldfrac=(N-1)/N;
    z=oldfrac*z+(exp(i*omega*N)*input(N))/N;
    %zimg=oldfrac*zimg+(imag(z))/N;
    %zreal=oldfrac*zreal+(imag(z))/N;
    zmean=oldfrac*zmean+abs(z)/N;
    zdelta=oldfrac*zdelta+(abs(z)-zmean.^2)/N;
    zang=atan2(imag(z),real(z))*180/pi;
    zmag=sqrt(real(z).^2+imag(z).^2);
    %magtmp(N)=sqrt(real(z)^2+imag(z)^2);
    %magtmpsigma=std(magtmp);
    %angtmp(N)=atan2(imag(z),real(z))*180/pi;
    %angtmpsigma=std(angtmp);
    tmp(N)=z;
    %tmp2(N)=zimgsigma;
    %plot(tmp(1:N));
    %hold on;
    %plot(tmp2(1:N),'r');title(N);
    %hold off;
    %cjfnormdist2([magtmpsigma angtmpsigma],[magtmp(N) angtmp(N)]);
    cjfnormdist2([zdelta zdelta],[real(z) imag(z)]);title(N);
    %plot(normpdf(-180:180,zang,zdelta*10));title(N);
    pause(.01);
end