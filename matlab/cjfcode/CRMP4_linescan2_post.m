startpoint=1;
endpoint=6;
width=endpoint-startpoint;
clear full_ave;
clear full_ave50;
clear full_point;
clear full_point50;
full_point=zeros(9,width);
full_point50=zeros(9,width);
full_ave=zeros(9,width);
full_ave50=zeros(9,width);
pointer=0;
for N=startpoint:endpoint
    pointer=pointer+1;
    load(sprintf('/Users/coreyflynn/Desktop/crmp4 lgn/F07-007 Adult/CRMP4_linescan_analysis/CRMP4%g.tif_linescan.mat',N));
    full_point(:,pointer)=point./point(1);
    full_point50(:,pointer)=point50./point50(1);
    full_ave(:,pointer)=ave./ave(1);
    full_ave50(:,pointer)=ave50./ave50(1);
end
cjfbarplot(full_point,5);
title('PGN normalized full-point');
set(gca,'XTickLabel',{'PGN/PGN','PGN>A','A','Aon/off','A>A1','A1','A1on/off','A1>C','C'});

cjfbarplot(full_point50,6);
title('PGN normalized full-point50');
set(gca,'XTickLabel',{'PGN/PGN','PGN>A','A','Aon/off','A>A1','A1','A1on/off','A1>C','C'});

cjfbarplot(full_ave,7);
title('PGN normalized full-ave50');
set(gca,'XTickLabel',{'PGN/PGN','PGN>A','A','Aon/off','A>A1','A1','A1on/off','A1>C','C'});

cjfbarplot(full_ave50,8);
title('PGN normalized full-ave');
set(gca,'XTickLabel',{'PGN/PGN','PGN>A','A','Aon/off','A>A1','A1','A1on/off','A1>C','C'});

a_size=size(full_point50);
simple_analysis=zeros(2,a_size(2)*3);
simple_analysis(1,1:a_size(2))=full_point50(2,:);
simple_analysis(1,a_size(2)+1:a_size(2)*2)=full_point50(5,:);
simple_analysis(1,a_size(2)*2+1:a_size(2)*3)=full_point50(8,:);
simple_analysis(2,1:a_size(2))=full_point50(3,:);
simple_analysis(2,a_size(2)+1:a_size(2)*2)=full_point50(6,:);
simple_analysis(2,a_size(2)*2+1:a_size(2)*3)=full_point50(9,:);

cjfbarplot(simple_analysis,9);
title('Intercalated Layers Vs Main Layers');
set(gca,'XTickLabel',{'Intercalted','Main'});
