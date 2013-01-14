function a=FourierRetAnalysis(stringbase,repeat_time,start,finish)
%stringbase='/Volumes/TERABITHIA2/Data 2005-2007/F07-274/Data_E1B';
a.z=zeros(1024);
a.meanmap=zeros(1024);
a.varmap=zeros(1024);
omega=2*pi/repeat_time;
cycle=0;
pointer=0;
%start=72;
%finish=360;
for N=start:finish
    s=[stringbase num2str(N) '.BLK'];
    blktmp=blkread(s);
    for j=1:10;
        pointer=pointer+1;
        oldfrac=(pointer-1)/(pointer);
        oldfracm=(N*10+j-1)/(N*10+j);
        a.z=oldfrac*a.z+(exp(i*omega*(pointer))*blktmp.data(:,:,j)/(pointer));
        a.meanmap=oldfracm*a.meanmap+(exp(i*omega*(N*10+j))*blktmp.data(:,:,j)/(N*10+j));
        if mod((N*10+j),repeat_time)==0
            cycle=cycle+1;
            cyclefrac=cycle-1/cycle;
            a.varmap=((cyclefrac*a.varmap+((a.z-a.meanmap).^2/cycle))/cycle).^.5;
            subplot(3,1,1);imagesc(angle(a.z));colorbar; title(sprintf('Cycle %d angle',cycle));drawnow;
            subplot(3,1,2);imagesc(angle(a.meanmap));colorbar; title(sprintf('Cycle %d mean angle',cycle));drawnow;
            subplot(3,1,3);imagesc(abs(a.varmap));colorbar; title(sprintf('Cycle %d variance',cycle));colorbar;drawnow;
            a.z=zeros(1024);
            pointer=0;
        end
        %figure(1);subplot(2,2,1);hist(reshape(angle(a.z),[1
        %1024^2]),100);title(sprintf('cycle %d, image
        %%d',cycle+1,N*10+j));drawnow;
    end
    disp(sprintf('block %d',N));
end
a=z;