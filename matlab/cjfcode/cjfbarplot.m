function cjfbarplot(input,fig_num)
figure(fig_num);
insize=size(input);
barh=bar(mean(input,2));
baseh=get(barh(1),'BaseLine');
set(baseh,'BaseValue',min(mean(input,2))-min(std(input,1,2)/sqrt(insize(2))));
hold on;
errorbar(mean(input,2),std(input,1,2)/sqrt(insize(2)),'k','LineStyle','none');
point=1;
[p,tbl,stats] = anova1(input',{},'off');
if p<.05
    [c,m] = multcompare(stats,'ctype','lsd','display','off');

    c_size=size(c);
    for N=1:c_size(1)
            if c(N,3)>=0 && c(N,5)<=0 || c(N,3)<=0 && c(N,5)>=0
            else
                 region_mark=NaN(insize(1),1);
                 region_mark(c(N,1):c(N,2))=max(mean(input,2))+(max(mean(input,2))/100)*point;
                 plot(region_mark,'k');
                 point=point+1;
            end
    end
end
hold off;