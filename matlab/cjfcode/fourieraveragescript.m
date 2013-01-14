%Simple script to generate a stack of images in ten degree bins from 10
%minutes of fourier type data, ommitting the first and last minutes.
cycle=0;
averagestack=zeros(1024,1024,36);
stringbase='/Volumes/TERABITHIA2/Data 2008/F08_103/Day2/Data_E5B';  
for N=36:215
      if mod(N,36)==0
          oldfrac=cycle/(cycle+1);
          cycle=cycle+1;
      end
      s=[stringbase num2str(N) '.BLK'];
      tmp=blkread_longdaq(s);
      averagestack(:,:,mod(N,36)+1)=averagestack(:,:,mod(N,36)+1)*oldfrac+mean(tmp.data,3)/cycle;
      disp(sprintf('adding to bin %d from cycle %d',mod(N,36)+1,cycle));
end