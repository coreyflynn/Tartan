for N=2:7
    tmp=eval(sprintf('data.slide1_%d.MLmean',N));
    tmp=tmp/max(tmp);
    %disp(sprintf('slide1_%d Lateral mean= %d',N,mean(tmp(1:round(length(tmp)/2)))));
    disp(sprintf('slide1_%d Medial mean= %d, Lateral mean= %d',N,mean(tmp(round(length(tmp)/2:length(tmp))))...
        ,mean(tmp(1:round(length(tmp)/2)))));
end