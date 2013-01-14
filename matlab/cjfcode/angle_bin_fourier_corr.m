step=10;
datacorr=zeros(180/step,10);
point=1;
for N=.0001:step:179
    if N-step/2<0
        tmpmask=(dataregion==1 & (anglemap_final>=180-step/2 | anglemap_final<N+step/2));
    else
        tmpmask=(dataregion==1 & (anglemap_final>=N-step/2 & anglemap_final<N+step/2));
    end
    for j=1:10
        tmp=anglemap(:,:,j);
        datacorr(point,j)=corr2(anglemap_final.*tmpmask,tmp.*tmpmask);
    end
    plot(datacorr(point,:),'Color',testcmap(ceil(N),:));drawnow;hold on;
    point=point+1;
end
hold off;
    