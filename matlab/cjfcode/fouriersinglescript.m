%%used to generate a single pixel stack from a fourier type experiement for
%%orientation response angle estimation.
singlepixel=zeros(1,2880);
stringbase='/Users/jcrowley/Desktop/F07-269 analysis/Data_E0B'; 
pointer=0;
for N=36:324
    s=[stringbase num2str(N) '.BLK'];
    tmp=blkread(s);
    disp(sprintf('processing block %d of 288',N-35));
    for j=1:10
        pointer=pointer+1;
        singlepixel(pointer)=tmp.data(500,600,j);
    end
end
    