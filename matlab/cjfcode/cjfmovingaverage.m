function filtered_signal=cjfmovingaverage(signal,window)
filtered_signal=zeros(1,length(signal));
tmp=zeros(1,length(signal)+window);
tmp(window/2+1:window/2+length(signal))=signal;
tmp(1:window/2)=signal(1);
tmp(window/2+length(signal):length(tmp))=signal(length(signal));
for i=1:length(signal)
    filtered_signal(i)=mean(tmp(i:i+window));
end