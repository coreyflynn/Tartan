%check spot areas
refs=1:length(x);
sums=[];
for N=1:length(x)
    found=find(domainIm==N);
    sums=horzcat(sums,sum(Cy3.im(found)));
end
found=find(sums==0);
x(found)=[];
y(found)=[];
refs(found)=[];

%find significant spots
ratios=[];
for N=1:length(refs)
    found=find(domainIm==refs(N));
    ratios=horzcat(ratios,sum(Cy3.im(found))/sum(Cy5.im(found)));
end
rMean=mean(ratios);
rStd=std(ratios);
posSig=find(ratios>(rMean+rStd*2));
negSig=find(ratios<(rMean-rStd*2));