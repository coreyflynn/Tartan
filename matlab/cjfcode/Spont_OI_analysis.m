%%
h=waitbar(0,'Calculating Frame-wise Correlations');
corrlist=[];
old=cpp_read2('/Volumes/TERABITHIA2/Data 2005-2007/F07-274/Spontaneous/raw_im1');
for N=2:360
    new=cpp_read2(sprintf('/Volumes/TERABITHIA2/Data 2005-2007/F07-274/Spontaneous/raw_im%d',N));
    corrlist=horzcat(corrlist,corr2(old,new)-1);
    plot(corrlist);drawnow;
    old=new;
    waitbar(N/360,h,'Calculating Frame-wise Correlations');
end
close(h);
%%
stackpointer=1;
stack=zeros(1024,1024,2);
fractionpointer=1;
minval=min(corrlist);
tmpav=cpp_read2('/Volumes/TERABITHIA2/Data 2005-2007/F07-274/Spontaneous/raw_im1');
h=waitbar(0,'Splitting seqeunce into frames at correlation dips');
for N=1:length(corrlist);
    if corrlist(N)<-1.74e-05
        stack(:,:,stackpointer)=tmpav;
        stackpointer=stackpointer+1;
        tmpav=zeros(1024,1024);
        fractionpointer=0;
        ssize=size(stack);
        imagesc(cjf_band_filter_2D(stack(:,:,ssize(3))-mean(stack,3),1024/6.5,[.5 2]));colormap(gray);title(sprintf('epoch %d',stackpointer));drawnow;
    end
    new=cpp_read2(sprintf('/Volumes/TERABITHIA2/Data 2005-2007/F07-274/Spontaneous/raw_im%d',N));
    tmpav=tmpav*fractionpointer/(fractionpointer+1)+new/(fractionpointer+1);
    waitbar(N/length(corrlist),h,'Splitting seqeunce into frames at correlation dips');
end
close(h);
%%
subplot(1,1,1);imagesc(stack(:,:,1));colormap(gray);title('select normalization mask');
mask=roipoly;
first=stack(:,:,ssize(3));
for N=1:ssize(3)
    second=stack(:,:,N);
    ratio=mean2(first(mask==1)./second(mask==1));
    subplot(5,5,N);imagesc(cjf_band_filter_2D(first*ratio-second,1024/6.5,[.5 2]));drawnow;
    first=second;
    %subplot(3,5,N);imagesc(mask.*medfilt2((first*ratio-tmp)));drawnow;
end
