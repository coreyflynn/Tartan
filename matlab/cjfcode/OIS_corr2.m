function [f]=OIS_corr2(data,reference)
% Usage ... f=OIS_corr2(data,reference)
%
% reference - reference waveform for correlation

% Image-course approach


sumim=0;
sumref=0;
count=0;
sumnx=0; sumny=0; sumnxy=0; sumnx2=0; sumny2=0;

%t=clock;
%disp(['Time:']);
%disp(t);
disp(['Initiating Analysis...']);

meanim=mean(data,3);
meanref=mean(reference);

for m=1:size(data,3),
  sumnx2=sumnx2+(reference(m)-meanref).*(reference(m)-meanref);
  sumny2=sumny2+(data(:,:,m)-meanim).*(data(:,:,m)-meanim);
  sumnxy=sumnxy+(reference(m)-meanref)*(data(:,:,m)-meanim);
end;

den=((sumnx2^(0.5))*(sumny2.^(0.5)));

f=zeros(size(den));
f(find((den==0)|(abs(den)<1e-6)))=0;
ii=find(abs(den)>=1e-6);
f(ii)=sumnxy(ii)./den(ii);


% convert r to t, just in case
%t=f*sqrt(count-1-2)/((1-f.*f).^0.5);

%disp(['Time: ']);
%disp(clock-t);
disp(['Done...']);

