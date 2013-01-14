for N=38:55
    s=['/Users/jcrowley/Desktop/F07-249 8-bit diffs/F07-249' num2str(N) '.tif'];
    map=imread(s);
    maskedmap=double(map).*double(mask);
    maskedmap(find(mask==0))=-1;
    cpp_write2('F07-249masked.mpp',maskedmap);
    analyse_map('F07-249masked.mpp',150.6,0,2.5,0.3,2,0.1,1,1);
    tmp=cpp_read2('F07-249masked.mpp');
    figure(10);subplot(3,1,1);imagesc(tmp);colormap(gray);
    tmp=cpp_read2('F07-249masked_preprocessed.mpp');
    figure(10);subplot(3,1,2);imagesc(tmp);colormap(gray);
    tmp=cpp_read2('F07-249maskedlocal_w.mpp');
    figure(10);subplot(3,1,3);imagesc(tmp);colorbar;
    s=['/Users/jcrowley/Desktop/F07-249 8-bit diffs/wavelength_data' num2str(N) '.tif'];
end