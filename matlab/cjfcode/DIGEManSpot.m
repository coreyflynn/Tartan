function DIGEManSpot(Cy3,Cy5)
Cy5=max(Cy5.origim(:))-Cy5.origim;
Cy3=max(Cy3.origim(:))-Cy3.origim;
h=figure;
him=imagesc(Cy3);
imscrollpanel(h,him);colormap(gray);
imoverview(him);
immagbox(h,him);
check=1;
spotnum=[];
difflist=[];
ratiolist=[];
iter=0;
while check==1
    mask=roipoly;
    found=find(mask==1);
    ratio=sum(sum(Cy3(found)))/sum(sum(Cy5(found)));
    diff=sum(sum(Cy3(found)))-sum(sum(Cy5(found)));
    iter=iter+1;
    spotnum=vertcat(spotnum,iter);
    difflist=vertcat(difflist,diff);
    ratiolist=vertcat(ratiolist,ratio);
    dlgans=questdlg('Characterize another spot?');
    if strcmp(dlgans,'Yes')==1
        check=1;
    else
        check=0;
    end
end
close(h);
f=figure('Position',[300 300 450 270]);
cnames = {'Spot','Ratio','Difference',}; 
dat=horzcat(spotnum,ratiolist,difflist);
uitable('Data',dat,'ColumnName',cnames,... 
            'Parent',f,'Position',[20 20 400 200]);