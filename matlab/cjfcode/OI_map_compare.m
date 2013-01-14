function ccVal=OI_map_compare(baseMap)
%read files to compare
[files,path]=uigetfile('Multiselect','on');
pos=zeros(1024);
neg=zeros(1024);
for ii=1:length(files)
    imTmp=blkread_vdaq(sprintf('%s%s',path,files{1}));
    imData=imTmp.data;
    pos=pos+imData(:,:,:,2)+imData(:,:,:,4);
    neg=neg+imData(:,:,:,3)+imData(:,:,:,5);
end
testMap=pos./neg;
ccVal=corr2(baseMap,testMap);