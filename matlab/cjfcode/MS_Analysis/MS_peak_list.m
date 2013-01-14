function [massdata,intdata,slidmean,slidstd,output_peaks]=MS_peak_list(varargin)
%

%% read the pre-processed data into a mass array and an intensity array
thresh=varargin{1};
if nargin==1
[file,path]=uigetfile({'*.txt'},'Select Data Explorer Output File'...
   ,'~/Desktop');
elseif nargin==3
    file=varargin{2};
    path=varargin{3};
end
    
disp('reading text file data...');
fid=fopen(sprintf('%s/%s',path,file));
celltext=textscan(fid,'%s %s');
fclose(fid);
masstext=celltext{1};
inttext=celltext{2};

masstext=masstext(10:length(masstext));
inttext=inttext(10:length(inttext));

massdata=zeros(1,length(masstext));
intdata=zeros(1,length(inttext));
for N=1:length(massdata)
    massdata(N)=str2num(masstext{N});
    intdata(N)=str2num(inttext{N});
end

%% Calculate the local intensity mean and select points that are above a 
%% threshold  over that mean.  Typically this will be a value of 2 times
%% the mean.

%calculate a sliding window average and standard deviation at a widht of
%1000 mass observations.
disp('Calculate local means and standard deviations');
slidmean=zeros(length(intdata),1);
slidstd=zeros(length(intdata),1);
slidwindow=intdata(1:101);
for N=51:length(intdata)-50
    slidmean(N)=mean(slidwindow);
    slidstd(N)=std(slidwindow);
    slidwindow=circshift(slidwindow,[0 -1]);
    try
        slidwindow(101)=intdata(N+51);
    catch ME
        disp('finished mean and standard deviation');
    end
end

% Select points that are x times the mean.
disp('finding significant peaks');
sigpeaks=zeros(length(intdata),1);
for N=51:length(intdata)-50
    if intdata(N)>=slidmean(N)*thresh
        sigpeaks(N)=intdata(N);
    else
        sigpeaks(N)=0;
    end
end

load('/Users/coreyflynn/CJFScripts/m-files/cjfcode/MS_Analysis/typsin_peaks.mat');
sigpeaks2=sigpeaks;
found=find(sigpeaks>0);
for N=1:length(found)
for M=1:length(trypsin_peaks)
if massdata(found(N))>trypsin_peaks(M)-.5
if massdata(found(N))<trypsin_peaks(M)+.5
sigpeaks2(found(N))=0;
end
end
end
end

found=find(sigpeaks2>0);

for N=1:length(found);
output_peaks(N)=massdata(found(N));
output_int(N)=intdata(found(N));
end

%only keep peaks above 1000
try
output_peaks(output_peaks<1000)=[];
output_int(output_peaks<1000)=[];
catch
    output_peaks=0;
    output_int=0;
end
%generate the output files.
filetok=strtok(file,'.');
if isdir(sprintf('%s/MS_sigpeaks/%s',path,filetok))==0
    mkdir(sprintf('%s/MS_sigpeaks/%s',path,filetok));
end
if isdir(sprintf('%s/msd/%s',path,filetok))==0
    mkdir(sprintf('%s/msd/%s',path,filetok));
end
try
    xlswrite(sprintf('%s/MS_sigpeaks/%s/%s_sigpeaks_%gxbase.xls'...
        ,path,filetok,filetok,thresh),output_peaks');
end
writemsd(path,filetok,output_peaks,output_int,thresh);

function writemsd(path,filetok,output_peaks,output_int,thresh)
%output function for mmass compatable xml files
f=fopen(sprintf('%s/msd/%s/%s_sigpeaks_%gxbase.msd'...
       ,path,filetok,filetok,thresh),'w');

disp(f)
%write header info
fprintf(f,'<?xml version="1.0" encoding="utf-8" ?>\n<mSD version="2.0">\n\n');

%write experiment description -- Change field names and values as desired 
fprintf(f,'  <description>\n');
fprintf(f,sprintf('    <title>%s_sigpeaks_%gxbase</title>\n',filetok,thresh));
fprintf(f,sprintf('    <date value="%s" />\n',date));
fprintf(f,sprintf('    <operator value="%s" />\n','Corey Flynn'));
fprintf(f,sprintf('    <contact value="%s" />\n','cjflynn@andrew.cmu.edu'));
fprintf(f,sprintf('    <institution value="%s" />\n','Carnegie Mellon University'));
fprintf(f,sprintf('    <instrument value="%s" />\n','Voyager DE'));
fprintf(f,'  </description>\n\n\n');

%write the peak list
fprintf(f,'  <peaklist>\n');
for N=1:length(output_peaks)
    fprintf(f,sprintf('    <peak mz="%f" intensity="%f" />\n'...
        ,output_peaks(N),output_int(N)));
end
fprintf(f,'  </peaklist>\n');
fprintf(f,'</mSD>');
fclose(f);
