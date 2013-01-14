function Epi_CRMP4_analysis
%%
%Prompts user for an image file
try
    startpath=evalin('base','startpath;');
    [file,dir]=uigetfile('*.*','select image to analyze',startpath);
    assignin('base','startpath',dir);
catch
    [file,dir]=uigetfile('*.*','select image to analyze','~/Desktop');
    assignin('base','startpath',dir);
end
%% Open image file
im=tiffread2([dir file]);
shrink_factor=2;

crmp4im=imresize(im(1).data,size(im(1).data)/shrink_factor);
CTBim=imresize(im(2).data,size(im(1).data)/shrink_factor);
%% Prompts User to select a background region for comparision to LGN data
figure(1);subplot(1,1,1);imagesc(crmp4im);title('select background ROI');colormap(gray);
[bgmask,xi,yi]=roipoly;
crmp4bgmean=mean2(crmp4im(bgmask==1));
CTBbgmean=mean2(CTBim(bgmask==1));
confirm='No';

%% Loop that allows the user to specify the analysis contour and length
while strcmp(confirm,'No')==1
    subplot(1,1,1);imagesc(CTBim);
    title('Select Analysis Contour');
    [cx,cy,c]=improfile;
    line(cx,cy);
    title('Select Length')
    [cdist,userang]=drawbins(gca,cx,cy);
    confirm=questdlg('Bin Position OK?');
end

%% Calculates a series of line scans and a filtered version of those line
%scans
window_size=10;
[raw,windowed]=get_windowed_data(crmp4im,cx,cy,cdist,window_size,userang);
linescan_data=mean(raw/crmp4bgmean,2);
crmp4Line=linescan_data;
mid=round(length(cx)/2);
linescan_mid_data=mean(raw(:,mid-12:mid+12)/crmp4bgmean,2);
linescan_mid_array=raw(:,mid-12:mid+12)/crmp4bgmean;
figure(1);subplot(1,2,1);imagesc(raw);title('CRMP4 raw');
subplot(1,2,2);imagesc(windowed);title(sprintf('%g pixel boxcar',window_size));
figure(2);subplot(1,3,1);imagesc(crmp4im);title('CRMP4 Analysis Bins');colormap(gray);
for N=11:30:length(cx)-10
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)]);
end
for N=mid-12:mid+12
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)],'Color','r');
end
line(xi,yi,'Color','g');
subplot(1,3,2);plot(linescan_data);title('Mean Linescan');
subplot(1,3,3);plot(linescan_mid_data,'r');title('Central Mean Linescan');
printstring=sprintf('%s/%s_%s%s',dir,file,'crmp4linescans','.png');
eval(sprintf('print -f2 -dpng %s',printstring));

%% Calculates a series of line scans and a filtered version of those line
%scans
window_size=10;
[raw,windowed]=get_windowed_data(CTBim,cx,cy,cdist,window_size,userang);
linescan_data=mean(raw/CTBbgmean,2);
ctbLine=linescan_data;
mid=round(length(cx)/2);
linescan_mid_data=mean(raw(:,mid-12:mid+12)/CTBbgmean,2);
linescan_mid_array=raw(:,mid-12:mid+12)/CTBbgmean;
figure(3);subplot(1,2,1);imagesc(raw);title('CTB raw');
subplot(1,2,2);imagesc(windowed);title(sprintf('%g pixel boxcar',window_size));
figure(4);subplot(1,3,1);imagesc(CTBim);title('CTB Analysis Bins');colormap(gray);
for N=11:30:length(cx)-10
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)]);
end
for N=mid-12:mid+12
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)],'Color','r');
end
line(xi,yi,'Color','g');
subplot(1,3,2);plot(linescan_data);title('Mean Linescan');
subplot(1,3,3);plot(linescan_mid_data,'r');title('Central Mean Linescan');
printstring=sprintf('%s/%s_%s%s',dir,file,'CTBlinescans','.png');
eval(sprintf('print -f4 -dpng %s',printstring));

figure(5);
plot(ctbLine,'b','LineWidth',5);hold on;
plot(crmp4Line,'r','LineWidth',5);hold off;
xlabel('Pixel Number','FontSize',20);
ylabel('Normalized Fluorescence','FontSize',20);
legend('CTB','CRMP4');
title(file);
cc=corrcoef(crmp4Line,ctbLine);
text(0,0,sprintf('corrcoef=%g',cc(2))); 
printstring=sprintf('%s/%s_%s%s',dir,file,'ctbCrmp4Comparison','.png');
eval(sprintf('print -f5 -dpng %s',printstring));



function [cdist,userang]=drawbins(axis,cx,cy)
cmid=round(length(cx)/2);
ang=atan2(cy(cmid+2)-cy(cmid-2),cx(cmid+2)-cx(cmid-2));
h=imdistline(axis,[cx(cmid),cx(cmid)+100*cos(ang-90)],[cy(cmid),cy(cmid)+100*sin(ang-90)]);
hapi=iptgetapi(h);
w=0;
while w==0
    w=waitforbuttonpress;
end
cdist=hapi.getDistance();
cpos=hapi.getPosition();
hapi.delete();
userang=atan2(cpos(2,2)-cpos(1,2),cpos(2,1)-cpos(1,1))/pi*180;
for N=11:5:length(cx)-10
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)]);
end

function [raw,windowed]=get_windowed_data(im,cx,cy,cdist,window_size,userang)
raw=zeros(round(cdist),length(cx)-20);
half_window=round(window_size/2);
windowed=zeros(round(cdist),length(cx)-20-half_window*2);
h=waitbar(0,'Taking Linescan Data');
for N=11:length(cx)-10
    waitbar(N/(length(cx)-20),h,'Taking Linescan Data');
    raw(:,N-10)=improfile(im,[cx(N),cx(N)+cdist*cosd(userang)],...
        [cy(N),cy(N)+cdist*sind(userang)],round(cdist));
end
for N=half_window+1:length(cx)-20-half_window
    waitbar(N/(length(cx)-20-half_window*2),h,'Taking Boxcar Data');
    windowed(:,N-half_window)=mean(raw(:,N-half_window:N+half_window),2);
end
close(h);

