function a=muncLaminarAnalysis(imnum,CTBflag)
path='/Users/jcrowley/Desktop/F07-139 P22 RLGN/594_DAPI triples/';
if CTBflag==0
    bg=double(imread(sprintf([path '594_%d.tif'],imnum)));
    munc=double(imread(sprintf([path 'munc%d.tif'],imnum)));
    dapi=double(imread(sprintf([path 'dapi%d.tif'],imnum)));
    subplot(1,1,1);imagesc(dapi);colormap(gray);title('please select the A1 layer');
    [A1mask,A1mx,A1my]=roipoly;
    line(A1mx,A1my,'LineWidth',3);
    title('Please Select A1/A region');
    [Amask,Amx,Amy]=roipoly;
    line(Amx,Amy,'LineWidth',3,'Color','r');
    a.A1muncmean=mean2(munc(A1mask==1 & Amask==1));
    a.Amuncmean=mean2(munc(A1mask==0 & Amask==1));
    a.A1ratiomean=mean2(munc(A1mask==1 & Amask==1)./bg(A1mask==1 & Amask==1));
    a.Aratiomean=mean2(munc(A1mask==0 & Amask==1)./bg(A1mask==0 & Amask==1));
    subplot(1,2,1);imagesc(munc.*(A1mask==1 & Amask==1));title('A1');
    subplot(1,2,2);imagesc(munc.*(A1mask==0 & Amask==1));title('A');
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
    