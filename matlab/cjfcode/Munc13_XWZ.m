function c=Munc13_XWZ
%custom analysis for munc13 expression in horizontal sections through
%the retina
[file,path]=uigetfile({'*.tif';'*.bmp';'*.jpg'},'Select Munc13 Image'...
    ,'~/Desktop');
filetok=strtok(file,'.');
muncim=double(imread(sprintf('%s%s',path,file)));
muncim=mean(muncim,3);
% 5µm radius, 10µm step at 4x on the urban lab neurolucida setup
c=cjf_line_average(muncim,10,20);
if isdir(sprintf('%sMunc13_XWZ',path))==0
    mkdir(sprintf('%sMunc13_XWZ',path));
end
xlswrite(sprintf('%sMunc13_XWZ/%s.xls',path,filetok),c');
save(sprintf('%sMunc13_XWZ/%s.mat',path,filetok),'c');

% h=figure;
% him=imagesc(muncim);
% imscrollpanel(h,him);colormap(gray);
% imoverview(him);
% c=improfile;

