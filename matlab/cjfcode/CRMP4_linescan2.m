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
%% Prompts User to select a background region for comparision to LGN data
figure(1);subplot(1,1,1);imagesc(im);title('select background ROI');colormap(gray);
[bgmask,xi,yi]=roipoly;
bgmean=mean2(im(bgmask==1));
confirm='No';

%% Loop that allows the user to specify the analysis contour and length
while strcmp(confirm,'No')==1
    subplot(1,1,1);imagesc(im);
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
linescan_data=mean(raw/bgmean,2);
mid=round(length(cx)/2);
linescan_mid_data=mean(raw(:,mid-12:mid+12)/bgmean,2);
linescan_mid_array=raw(:,mid-12:mid+12)/bgmean;
figure(1);subplot(1,2,1);imagesc(raw);title('raw');
subplot(1,2,2);imagesc(windowed);title(sprintf('%g pixel boxcar',window_size));
figure(2);subplot(1,3,1);imagesc(im);title('Analysis Bins');colormap(gray);
for N=11:30:length(cx)-10
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)]);
end
for N=mid-12:mid+12
    line([cx(N),cx(N)+cdist*cosd(userang)],[cy(N),cy(N)+cdist*sind(userang)],'Color','r');
end
line(xi,yi,'Color','g');
subplot(1,3,2);plot(linescan_data);title('Mean Linescan');
subplot(1,3,3);plot(linescan_mid_data,'r');title('Central Mean Linescan');

%% Generate four average arrays in the order of
%%[PGN,PGN>A,A,Aon/off,A>A1,A1,A1on/off,A1>C,C]

point=zeros(1,9);
point50=zeros(1,9);
ave=zeros(1,9);
ave50=zeros(1,9);
%plus two more to store the boundries of the regions defined below
r_start=zeros(1,9);
r_end=zeros(1,9);
%% Ask the user to specify regions of interest for each of the entries in
%%the four array created above
figure(3);
[point(1),ave(1),point50(1),ave50(1),r_start(1),r_end(1)]=get_region_data(linescan_data,linescan_mid_data,1,'PGN',[1,0,0]);
[point(2),ave(2),point50(2),ave50(2),r_start(2),r_end(2)]=get_region_data(linescan_data,linescan_mid_data,0,'PGN>A',[1,.5,0]);
[point(3),ave(3),point50(3),ave50(3),r_start(3),r_end(3)]=get_region_data(linescan_data,linescan_mid_data,1,'A',[1,1,0]);
[point(4),ave(4),point50(4),ave50(4),r_start(4),r_end(4)]=get_region_data(linescan_data,linescan_mid_data,0,'Aon/off',[.5,1,0]);
[point(5),ave(5),point50(5),ave50(5),r_start(5),r_end(5)]=get_region_data(linescan_data,linescan_mid_data,0,'A>A1',[0,1,0]);
[point(6),ave(6),point50(6),ave50(6),r_start(6),r_end(6)]=get_region_data(linescan_data,linescan_mid_data,1,'A1',[0,1,.5]);
[point(7),ave(7),point50(7),ave50(7),r_start(7),r_end(7)]=get_region_data(linescan_data,linescan_mid_data,0,'A1on/off',[0,1,1]);
[point(8),ave(8),point50(8),ave50(8),r_start(8),r_end(8)]=get_region_data(linescan_data,linescan_mid_data,0,'A1>C',[0,.5,1]);
[point(9),ave(9),point50(9),ave50(9),r_start(9),r_end(9)]=get_region_data(linescan_data,linescan_mid_data,1,'C',[0,0,1]);
hold off;

%% plot a summary bar graph
tmp=horzcat(point'/point(1),ave'/ave(1),point50'/point50(1),ave50'/ave50(1));
figure(4);barh=bar(tmp);
set(gca,'XTickLabel',{'PGN/PGN','PGN>A','A','Aon/off','A>A1','A1','A1on/off','A1>C','C'});
baseh=get(barh(1),'BaseLine');
set(baseh,'BaseValue',1);
title('PGN Normalized Expression');
legend('Full single','Full Ave','Mid50 Single','Mid50 Ave');


confirm=questdlg('Would you like to Save this Data?');
if strcmp(confirm,'Yes')==1
    figure(1);
    I_linescans = getframe(gcf);
    figure(2);
    I_summary = getframe(gcf);
    figure(3);
    I_regions = getframe(gcf);
    figure(4);
    I_hist = getframe(gcf);
    s=sprintf('%sCRMP4_linescan_analysis',startpath);
    if isdir(s)==0
        mkdir(s);
    end
    savepath=uigetdir(s,'Where would you like to save to?');
    imwrite(I_linescans.cdata,sprintf('%s/%s_%s%s',savepath,file,'linescans','.tif'));
    imwrite(I_summary.cdata,sprintf('%s/%s_%s%s',savepath,file,'summary','.tif'));
    imwrite(I_regions.cdata,sprintf('%s/%s_%s%s',savepath,file,'regions','.tif'));
    imwrite(I_hist.cdata,sprintf('%s/%s_%s%s',savepath,file,'hist','.tif'));
    s=sprintf('%s/%s_linescan.mat',savepath,file);
    save(s);
end

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
    
