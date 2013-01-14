for N=2:8
    tmp=eval(sprintf('data.slide1_%d.APmean',N));
    tmp=tmp/max(tmp);
    %disp(sprintf('slide1_%d monocular mean= %d',N,mean(tmp(1:round(length(tmp)/2)))));
    disp(sprintf('slide1_%d binocular mean= %d',N,mean(tmp(round(length(tmp)/2:length(tmp))))));
end