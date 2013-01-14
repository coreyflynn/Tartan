function CRMP4_linescan
%%
try
    startpath=evalin('base','startpath;');
    [file,dir]=uigetfile('*.*','select image to analyze',startpath);
    assignin('base','startpath',dir);
catch
    [file,dir]=uigetfile('*.*','select image to analyze','~/Desktop');
    assignin('base','startpath',dir);
end
im=imread([dir file]);
if ndims(im)==3
    im=mean(im,3);
end
subplot(1,1,1);imagesc(im);title('select background ROI');colormap(gray);
bgmask=roipoly;
bgmean=mean2(im(bgmask==1));
confirm='No';
while strcmp(confirm,'No')==1
    rval=inputdlg('rotation value');
    im=imrotate(im,str2double(rval{1}));
    imagesc(im);
    confirm=questdlg('Rotation OK?');
end
confirm='No';
while strcmp(confirm,'No')==1
    subplot(1,1,1);imagesc(im);
    title('Please Crop the Image');
    [tmp,rect]=imcrop;
    subplot(1,2,1);imagesc(im);rectangle('Position',rect);
    subplot(1,2,2);plot(mean(tmp,2)/bgmean);
    confirm=questdlg('Analysis OK?');
end


%[cx,cy,c,x,y]=improfile;
%c_ave=cjf_line_average(im,5);
%figure;plot(c_ave-bgmean);
