
function [pow,freq]=cjfpower(sig,sample_freq)
nyquist=sample_freq*2;
 sig_length=length(sig);
 freq=nyquist.*(0:round(sig_length/2))/round(sig_length/2);
ffted=fft(sig);
pow = ffted.*conj(ffted)/sig_length;
pow(1)=0;
loglog(freq,pow(1:round(sig_length/2)+1));
pow=pow(1:round(sig_length/2)+1);
title('Power Spectrum')


peak_freq=freq(find(pow==max(pow)));
dominant_freq=1/peak_freq