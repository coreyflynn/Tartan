function b=colornoise(N,T)
%%function to create colored noise from a linear function transformed with a given correlation time.  
%%This is then used as the basis to create colored noise by taking the fft of it and adding random noise 
%%in the frequency domain.
a=-N/20:1/10:N/20;
%Correlation function
CorSample=exp(-abs(a)/T);

FFTCor=fft(CorSample);

RandomNumbers(1:2,1:N+1)=0;

RandomNumbers(1,:)=randn(1,N+1);
RandomNumbers(2,:)=randn(1,N+1);
vector(1,:)=RandomNumbers(1,:);
vector(2,:)=RandomNumbers(2,:);
Coef=sqrt(abs(FFTCor)).*[vector(1,:)+i*vector(2,:)].*sqrt(N+1);
%If necessary, one can view or reuse the random numbers
X=ifft(Coef);
b=real(X);