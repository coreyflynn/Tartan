%This is the last script in a series to analyze fourier type data.  The
%processing pathway for fourier data is as follows:
%fourieraveragescript-->fourierdiffscript-->fourierwavescript.  This
%last script using the Wolf lab wavelength estimation machinery to estimate
%the preprocessed difference images generated with the first two scripts

%%first process the orientation data
savepath='/Users/jcrowley/Desktop/F07-269 analysis/';
for N=8:8
    s=[savepath 'orientation mpp/F07-269_orientation' num2str(N)];
    %%process using the default values for the wolf code.
    analyse_map(s,150.6,0,2.5,.3,2.0,.1,1,1);
    s=[savepath 'orientation mpp/F07-269_orientatlocal_w.mpp'];
    tmp=cpp_read2(s);
    s=[savepath 'orientation mpp/F07-269_orientation_local_w.mpp' num2str(N)];
    cpp_write2(s,tmp);
    figure(10);
    imagesc(tmp);
    s=[savepath 'orientation mpp/F07-269_orientat_preprocessed.mpp'];
    tmp=cpp_read2(s);
    s=[savepath 'orientation mpp/F07-269_orientation_preprocessed.mpp' num2str(N)];
    cpp_write2(s,tmp);

    
end
%%
for N=1:36
    s=[savepath 'direction mpp/F07-269_dirirection' num2str(N)];
    %%process using the default values for the wolf code.
    analyse_map(s,150.6,0,2.5,.3,2.0,.1,1,1);
    s=[savepath 'direction mpp/F07-269_dirlocal_w.mpp'];
    tmp=cpp_read2(s);
    s=[savepath 'direction mpp/F07-269_dirlocal_w.mpp' num2str(N)];
    cpp_write2(s,tmp);
    figure(10);
    imagesc(tmp);
    s=[savepath 'orientation mpp/F07-269_dir_preprocessed.mpp'];
    tmp=cpp_read2(s);
    s=[savepath 'orientation mpp/F07-269_dir_preprocessed.mpp' num2str(N)];
    cpp_write2(s,tmp);
end