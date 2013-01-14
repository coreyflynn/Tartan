function cjfangle_mean_estimate_chunked_mod(input,omega)
%%only one dimenstional as of yet...
z=0;
zdelta=0;
zmean=0;
for N=1:length(input)
    oldfrac=(N-1)/N;
    z=oldfrac*z+(exp(i*omega*N)*input(N))/N;
    if mod(N,180)==0
        zang=atan2(imag(z),real(z))*180/pi;
        zmag=sqrt(real(z).^2+imag(z).^2);
        %plot(normpdf(-180:180,zang,zdelta));title(N);
        %figure(3);
        %cjfnormdist2([zdelta zdelta],[real(z) imag(z)]);title(N);
        pause(.01);
        %s=['/Users/jcrowley/Desktop/Wolf code export images/real brain/' num2str(N) '.jpg'];
        %xlabel('real');
        %ylabel('imaginary');
        %saveas(gca,s);
        zdelta=0;
        zmean=0;
        z=0;
    end
    if N>=181
        z=oldfrac*z+(exp(i*omega*(mod(N,181)+1))*input(N))/mod(N,181)+1;
    end
    zmean=oldfrac*zmean+abs(z)/N;
    zdelta=oldfrac*zdelta+(abs(z)-zmean.^2)/N;
    tmp(N)=z;
    plot(tmp(1:N));title(N);
    %cjfnormdist2([magtmpsigma angtmpsigma],[magtmp(N) angtmp(N)]);
    pause(.01);
end