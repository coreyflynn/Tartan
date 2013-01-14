function out=CRMP4_linescan2_t0xls
[file,dir]=uigetfile('MultiSelect','on');
file
out=[];
for N=1:length(file)
    load(sprintf('%s%s',dir,file{N}));
    out=horzcat(out,ave50);
end