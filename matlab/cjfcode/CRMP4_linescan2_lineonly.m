function CRMP4_linescan2
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
im=imread([dir file]);
if ndims(im)==3
    im=rgb2gray(im);
end

%% Loop that allows the user to specify the analysis contour and length
confirm='No';
while strcmp(confirm,'No')==1
    subplot(1,1,1);imagesc(im);colormap(gray);
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
[raw,windowed]=get_windowed_data(im,cx,cy,cdist,window_size,userang);
linescan_data=mean(raw,2);
assignin('base','scan',linescan_data);
mid=round(length(cx)/2);
linescan_mid_data=mean(raw(:,mid-12:mid+12),2);
linescan_mid_array=raw(:,mid-12:mid+12);
figure(1);subplot(1,2,1);imagesc(raw);title('raw');
subplot(1,2,2);imagesc(windowed);title(sprintf('%g pixel boxcar',window_size));
figure(2);subplot(1,3,1);imagesc(im);title('Analysis Bins');colormap(gray);
for N=11:30:length(cx)-10
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)]);
end
for N=mid-12:mid+12
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)],'Color','r');
end
subplot(1,3,2);plot(linescan_data);title('Mean Linescan');
subplot(1,3,3);plot(linescan_mid_data,'r');title('Central Mean Linescan');

figure;plot(linescan_data./smooth(linescan_data,length(linescan_data)));
hold on;
plot(linescan_mid_data./smooth(linescan_mid_data,length(linescan_mid_data)),'r');
title('baseline subtracted');
legend('Full','Central');



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

function [single,ave,single50,ave50,x1,x2]=get_region_data(linescan,linescan50,min_flag,region_name,mc)
plot(linescan50);title(sprintf('Select begining of %s region',region_name));
[x1,y1]=ginput(1);
plot(linescan50);title(sprintf('Select end of %s region',region_name));hold on;
plot(round(x1),linescan50(round(x1)),'o','MarkerFaceColor',mc,'MarkerSize',10);
[x2,y2]=ginput(1);
plot(round(x2),linescan50(round(x2)),'o','MarkerFaceColor',mc,'MarkerSize',10);
region_mark=ones(1,length(linescan50));region_mark=region_mark*max(linescan50);
region_mark(1:round(x1)+1)=NaN;region_mark(round(x2)-1:length(linescan50))=NaN;
region_mark(round(x1))=linescan50(round(x1));region_mark(round(x2))=linescan50(round(x2));
plot(region_mark,'Color',mc);
text(x1,max(linescan50)+max(linescan50)/100,region_name,'Color',mc);
ave=mean(linescan(round(x1):round(x2)));
ave50=mean(linescan50(round(x1):round(x2)));
if min_flag==0
    single=max(linescan(round(x1):round(x2)));
    [single50,ind]=max(linescan50(round(x1):round(x2)));
else
    single=min(linescan(round(x1):round(x2)));
    [single50,ind]=min(linescan50(round(x1):round(x2)));
end
plot(round(x1)+ind-1,linescan50(round(x1)+ind-1),'p','MarkerFaceColor',mc,'MarkerSize',10);
x1=round(x1);
x2=round(x2);
    
