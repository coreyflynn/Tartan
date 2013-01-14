function a=CRMP4LaminarAnalysis(imnum,CTBflag)
path='/Users/jcrowley/Desktop/CRMP4 immuno/F07-221 P30/';
if CTBflag==0
    CRMP4=double(imread(sprintf([path 'CRMP4%d.tif'],imnum)));
    bg=double(imread(sprintf([path '594%d.tif'],imnum)));
    dapi=double(imread(sprintf([path 'DAPI%d.tif'],imnum)));
    subplot(1,1,1);imagesc(bg);colormap(gray);title('please select the A1 layer');
    [A1mask,A1mx,A1my]=roipoly;
    line(A1mx,A1my,'LineWidth',3);
    title('Please Select A layer');
    [Amask,Amx,Amy]=roipoly;
    line(Amx,Amy,'LineWidth',3,'Color','r');
    se=strel('disk',40);
    A1Border=imdilate(A1mask,se)-A1mask;
    subplot(2,2,1);imagesc(CRMP4.*~A1Border);title('A1 Border Region');
    subplot(2,2,2);imagesc(CRMP4.*~A1mask);title('A1 Lamina');
    subplot(2,2,3);imagesc(CRMP4.*~Amask);title('A Lamina');drawnow;
    %CRMP4Ratio=CRMP4./bg;
    CRMP4Ratio=CRMP4;
    a.LaminaMean=mean2(CRMP4Ratio(A1Border==1));
    a.A1mean=mean2(CRMP4Ratio(A1mask==1));
    a.Amean=mean2(CRMP4Ratio(Amask==1 & A1mask==0));
    Bardat=[a.LaminaMean/a.LaminaMean,a.A1mean/a.LaminaMean, a.Amean/a.LaminaMean];
    subplot(2,2,4);bar(Bardat,'r');title('1=Lamina Mean, 2=A1 Mean, 3=A Mean');
elseif CTBflag==1
    munc=double(imread(sprintf([path 'munc%d.tif'],imnum)));
    CTB=double(imread(sprintf([path 'CTB%d.tif'],imnum)));
    CTBmask=CTB>max(max(CTB))*.25;
    imagesc(CTB);colormap(gray);title('please select the A/A1 region');
    [Amask,Amx,Amy]=roipoly;
    line(Amx,Amy,'LineWidth',3,'Color','r');
    a.A1muncmean=mean2(munc(CTBmask==1 & Amask==1));
    a.Amuncmean=mean2(munc(CTBmask==0 & Amask==1));
end
    