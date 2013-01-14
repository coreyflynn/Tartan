%a=FourierVarAnalysis_stack(pathbase,experimentbase,repeat_time,start,finish,file_label)

function a=FourierVarAnalysis_stack(pathbase,experimentbase,repeat_time,start,finish,file_label)
stringbase=[pathbase experimentbase];
if isdir([pathbase '/Fourier Analysis'])==0
    mkdir([pathbase '/Fourier Analysis']);
end
if isdir([pathbase '/Fourier Analysis' '/' file_label])==0
    mkdir([pathbase '/Fourier Analysis' '/' file_label]);
end
cd([pathbase '/Fourier Analysis' '/' file_label]);
a.z=zeros(1024);
a.meanmap=zeros(1024);
a.varmap=zeros(1024);
omega=2*pi/repeat_time;
cycle=0;
pointer=0;
counter=0;
anglelist=[];
breakflag=0;
h=waitbar(0,sprintf('Processing image 1 of %d',(finish-start)*10+10));
%start=72;
%finish=360;
for N=start:finish
    s=[stringbase num2str(N) '.BLK'];
    blktmp=blkread(s);
    for j=1:10;
        counter=counter+1;
        pointer=pointer+1;
        oldfrac=(pointer-1)/(pointer);
        oldfracm=(N*10+j-1)/(N*10+j);
        a.z=oldfrac*a.z+(exp(i*omega*(pointer))*blktmp.data(:,:,j)/(pointer));
        a.meanmap=oldfracm*a.meanmap+(exp(i*omega*(N*10+j))*blktmp.data(:,:,j)/(N*10+j));
        if mod((N*10+j),repeat_time)==0
            figure(1);
            cycle=cycle+1;
            cyclefrac=cycle-1/cycle;
            a.varmap=((cyclefrac*a.varmap+((a.z-a.meanmap).^2/cycle))/cycle).^.5;
            subplot(3,1,1);imagesc(angle(a.z));colorbar; title(sprintf('Cycle %d angle',cycle));drawnow;
            cpp_write2([file_label sprintf(' Cycle %d angle.mpp',cycle)],angle(a.z));
            subplot(3,1,2);imagesc(angle(a.meanmap));colorbar; title(sprintf('Cycle %d mean angle',cycle));drawnow;
            cpp_write2([file_label sprintf(' Cycle %d mean angle.mpp',cycle)],angle(a.meanmap));            
            subplot(3,1,3);imagesc(abs(a.varmap));colorbar; title(sprintf('Cycle %d variance',cycle));colorbar;drawnow;
            cpp_write2([file_label sprintf(' Cycle %d variance.mpp',cycle)],abs(a.varmap)); 
            a.z=zeros(1024);
            pointer=0;
        end
        %figure(10);
        %anglelist=horzcat(anglelist,exp(i*omega*(pointer))*blktmp.data(512,512,j));
        %tmpplot=cjf_band_filter(abs(anglelist)-abs(mean(anglelist)),6,[.03 .04],0);
        %plot(tmpplot/max(tmpplot));hold on; plot((abs(anglelist)-abs(mean(anglelist)))/max(abs(anglelist)-abs(mean(anglelist))),'r');
        %drawnow;
        %hold off;
        waitbar(((cycle*repeat_time+pointer)/(finish-start)*10+10),h,sprintf('Processing image %d of %d',cycle*repeat_time+pointer,(finish-start)*10+10));
    end
end
close(h);
cd /Applications/MATLAB74