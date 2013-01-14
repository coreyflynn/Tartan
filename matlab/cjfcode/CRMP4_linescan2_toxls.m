function CRMP4_linescan2_toxls
confirm='Yes';
out=[];
dir=pwd;
while strcmp(confirm,'Yes')==1
    [file,dir]=uigetfile('*.mat','Choose file',dir);
    load(sprintf('%s%s',dir,file));
    out=vertcat(out,ave50);
    confirm=questdlg('more file for this animal?');
end
xlswrite('AnimalLinescanSummary.xls',out);
