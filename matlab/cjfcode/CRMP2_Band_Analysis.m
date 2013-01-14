function CRMP2_Band_Analysis
[file,dir]=uigetfile({'*.jpg'},'Select an Image'...
   ,pwd);
im=imread(sprintf('%s%s',dir,file));
im=flatShrinkIm(im);
[outerMask,innerMask]=getSliceMasks(im,1);
dlgans=questdlg('Trace Another Slice?');
if strcmp(dlgans,'Yes')==1
        check=1;
    else
        check=0;
end

while check==1
    [outerMasktmp,innerMasktmp]=getSliceMasks(im,0);
    outerMask=cat(3,outerMask,outerMasktmp);
    innerMask=cat(3,innerMask,innerMasktmp);
    dlgans=questdlg('Trace Another Slice?');
    if strcmp(dlgans,'Yes')==1
        check=1;
    else
        check=0;
    end
end
assignin('base','outerMask',outerMask);
assignin('base','innerMask',innerMask);

function [outerMask,innerMask]=getSliceMasks(im,firstFlag)
if firstFlag==0
    [file,dir]=uigetfile({'*.jpg'},'Select an Image'...
   ,pwd);
    im=imread(sprintf('%s%s',dir,file));
    im=flatShrinkIm(im);
    im=shrink3D(im,[500,500,1]);
end
imagesc(im);
outerMask=roipoly;
imagesc(im.*outerMask);title('outline band edge');
innerMask=outerMask*0;
check=1;
while check==1
    tmpMask=roipoly;
    innerMask=(innerMask+tmpMask)>0;
    imagesc(im.*~innerMask);
    dlgans=questdlg('Trace Another Band?');
    if strcmp(dlgans,'Yes')==1
        check=1;
        title('outline band edge');
    else
        check=0;
    end
end

function im=flatShrinkIm(im)
if size(im,3)==3
    im=mean(im,3);
end
im=shrink3D(im,[round(size(im,1)*.25),round(size(im,2)*.25),1]);
    
