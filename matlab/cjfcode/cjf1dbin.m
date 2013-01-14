%function cjf1dbin(signal,binfactor)
%this function bins a one dimensional signal by a factor of binfactor.  For
%example, if binfactor=2, a 100 point signl would be binned to a 50 point
%signal.  The algorithm finds any remainder in the signal beyond the last
%full bin and pads it with the value of the last point in the signal to
%fill the last bin.

function a=cjf1dbin(signal,binfactor)
remainder=mod(length(signal),binfactor);
a=zeros(1,(length(signal)+remainder)/binfactor);
signal(length(signal):length(signal)+remainder)=signal(length(signal));
apointer=0;
for i=1:binfactor:length(signal)-remainder
    apointer=apointer+1;
    a(apointer)=mean(signal(i:i+remainder));
end