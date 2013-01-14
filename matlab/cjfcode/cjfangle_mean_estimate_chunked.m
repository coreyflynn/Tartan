function cjfangle_mean_estimate_chunked(input,omega)
%%only one dimenstional as of yet...
z=0;
zdelta=0;
zmean=0;
for N=1:length(input)
    oldfrac=(N-1)/N;
    z=oldfrac*z+(exp(i*omega*N)*input(N))/N;
    if mod(N,180)==0
        figure(3);
        cjfnormdist2([zdelta zdelta],[real(z) imag(z)]);title(N);
        pause(.01);
        zdelta=0;
        zmean=0;
    end
    zmean=oldfrac*zmean+abs(z)/N;
    zdelta=oldfrac*zdelta+(abs(z)-zmean.^2)/N;
end