%This funciton takes a one dimensional signal and applies a bandpass filter to it in the
%frequency domain.
%
% USAGE: filtered_signal=cjf_band_filter(series,sampling,band,plotflag)
%
%VARIABLE DEFINITIONS:
%series- input data series to be filtered
%
%sampling- the rate in Hz at which the signal was sampled
%
%band- 1x2 vector specifying the low and high ends of the band pass in Hz
%
%plotflag- options for plots, value of 1 gives fourier components and a
%pre filter_power spectrum_post filter graphs. a value of 2 give just the
%second plot.  Any other value gives just the filtered signal

function filtered_signal=cjf_band_filter(series,sampling,band,plotflag)
ffted=fft(series);
freq=sampling/length(series)*(0:floor(length(series)/2));
filter=zeros(1,length(series));
target=find(freq>=band(1) & freq<=band(2));
filter(target)=1;
filtered_fft=ffted.*filter;
filtered_signal=real(ifft(filtered_fft));
if plotflag==1
    figure(1); subplot(2,2,1);plot(real(ffted));title('realfft');
    figure(1); subplot(2,2,2);plot(imag(ffted));title('imagfft');
    figure(1); subplot(2,2,3);plot(abs(ffted));title('mag');
    figure(1); subplot(2,2,4);plot(angle(ffted));title('phase');
    figure(2);
    pow=real(fft(series,length(series)).*conj(fft(series/length(series)))/length(series));
    pow(1)=[];
    subplot(3,1,1);plot(series);title('original signal');
    subplot(3,1,2);loglog(freq(1:floor(length(series)/2)),pow(1:floor(length(series)/2)));title('power spectral desnity');
    xlabel('Frequency (Hz)');ylabel('amplitude');
    subplot(3,1,3);plot(filtered_signal);title(sprintf('filtered from %dHz to %dHz',band(1),band(2)));
elseif plotflag==2
    figure(1);
    pow=real(fft(series,length(series)).*conj(fft(series/length(series)))/length(series));
    pow(1)=[];
    subplot(3,1,1);plot(series);title('original signal');
    subplot(3,1,2);loglog(freq(1:floor(length(series)/2)),pow(1:floor(length(series)/2)));title('power spectral desnity');
    xlabel('Frequency (Hz)');ylabel('amplitude');
    subplot(3,1,3);plot(filtered_signal);title(sprintf('filtered from %dHz to %dHz',band(1),band(2)));
end