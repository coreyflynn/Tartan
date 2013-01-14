function MS_peak_list_batch
[file,path]=uigetfile({'*.txt'},'Select Data Explorer Output Files'...
   ,'~/Desktop','MultiSelect','on');
wb=waitbar(0,'MS Batch progress');
for ii=1:length(file)
    waitbar(ii/length(file),wb,'MS Batch progress');
    for jj=2:5
        [massdata,intdata,slidmean,slidstd,output_peaks]=...
            MS_peak_list(jj,file{ii},path);
    end
end
close(wb);