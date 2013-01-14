function CRMP2_stack_analysis(varargin)
% read in a pre-aligned tiff stack to operate on unless one is given by the
% user
if nargin==0
    [file,path]=uigetfile({'*.tif';'*.tiff'},'Select Tiff Stack','~/Desktop');
    tiffstack=tiffread2(sprintf('%s%s',path,file));
elseif nargin ==1
    tiffstack=varargin{1};
end
%filter each section in the series with a fermi filter at 300µm and subtract
%that as a backgound image
filtered=zeros(size(tiffstack(1).data,1),size(tiffstack(1).data,2));
for N=1:length(tiffstack)
    disp(sprintf('filtering image %g of %g',N,length(tiffstack)));
    im=double(tiffstack(N).data);
    %bg=fermifilt(im,1000,2);
    %used for image shunk by a factor of 8
    bg=fermifilt(im,1000,.5*8);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filtered=im-bg;
    cpp_write2(sprintf('%s/filtered%g',path,N),filtered);
end
assignin('base','path',path);

path=evalin('base','path');
for N=1:length(tiffstack)
    filtered=cpp_read2(sprintf('%s/filtered%g',path,N));
    disp(sprintf('Taking the optical density of image %g of %g',N,length(tiffstack)));
    %slicedata=rind(double(filtered),400);
    %used for image shunk by a factor of 8
    slicedata=rind(double(filtered),400/8);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    slicedata.image=filtered;
    assignin('base',sprintf('slice%g',N),slicedata);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         START POINT ANALYSIS                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%define a processing mask for each section in the slice series
% path=evalin('base','path');
% for N=1:10
%     filtered=cpp_read2(sprintf('%s/filtered%g',path,N));
%     disp(sprintf('Masking Slice %g of %g for Cellular Analysis',N,10));
%     slice=evalin('base',sprintf('slice%g',N));
%     count=0;
%     for M=2:100:length(slice.cx)-1
%         count=count+1;
%         Y=[slice.cy(M+1) slice.cy(M-1)];
%         X=[slice.cx(M+1) slice.cx(M-1)];
%         ang=atan2(Y(1)-Y(2),X(1)-X(2));
%         x1(count)=slice.cx(M)+cos(ang+deg2rad(90))*100;
%         y1(count)=slice.cy(M);
% 
%         x2(count)=x1(count)+cos(ang+deg2rad(90))*300;
%         y2(count)=y1(count)+sin(ang+deg2rad(90))*300;
%     end
%     mask=roipoly(filtered,cat(2,x1,fliplr(x2)),cat(2,y1,fliplr(y2)));
%     masked_f=filtered.*mask;
%     imagesc(masked_f);colormap(gray);drawnow;
%     cpp_write2(sprintf('%s/masked_f%g',path,N),masked_f);
% end

%compute a thresholded binary image from each masked image and compute the
%centroids of all found objects in the images
path=evalin('base','path');
% STR=strel('disk',3);
% for N=1:10
%     masked_f=cpp_read2(sprintf('%s/masked_f%g',path,N));
%     disp(sprintf('Getting centroids from binary image %g of %g',N,10));
%     binary_f=masked_f<-15;
%     binary_f=imopen(binary_f,STR);
%     cpp_write2(sprintf('%s/binary_f%g',path,N),double(binary_f));
%     labeled=bwlabel(binary_f);
%     cpp_write2(sprintf('%s/labeled_f%g',path,N),double(labeled));
%     slice_stats(N).prop=regionprops(labeled);
% end
% assignin('base','slice_stats',slice_stats); 
% figure;
% 
% masked_f=cpp_read2(sprintf('%s/masked_f1',path));
% slice_stats=evalin('base','slice_stats');
% for N=1:10
%     tmp=masked_f*0;
% cent=cat(1,slice_stats(N).prop.Centroid);
%  plot3(cent(:,1),cent(:,2),ones(1,length(cent))*N,'k*');drawnow;pause(1);hold on;
%     for M=1:size(cent,1)
%     tmp(round(cent(M,2)),round(cent(M,1)))=1;
%     end
% %imagesc(tmp);drawnow;
% cpp_write2(sprintf('%s/centroidim%g',path,N),double(tmp));
% end


% path=uigetdir('~/Desktop');
% for N=1:10
%     centroidim=cpp_read2(sprintf('%s/centroidim%g',path,N));
%     disp(sprintf('Taking the optical density of centroid image %g of %g',N,10));
%     slicedata=rind(double(centroidim),400,evalin('base',sprintf('slice%g',N)));
%     assignin('base',sprintf('cellslice%g',N),slicedata);
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          END POINT ANALYSIS                                            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% %%FINISHING CODE%%

for N=1:10
tmp1=evalin('base',sprintf('slice%g_1bin.cx',N));
tmp2=evalin('base',sprintf('slice%g_1bin.cx',10));
mid=round(length(tmp1)/2);
offset=round((tmp2(mid)-tmp1(mid))/1)
tmplength=length(tmp1);
densitytmp=evalin('base',sprintf('slice%g_1bin.density',N));%densitytmp=cjf_band_filter(densitytmp,1,[1/20 1/10 ],0);
try
dorsal_1bin(N,offset+1:length(densitytmp)+offset)=densitytmp;
catch M
dorsal_1bin(N,offset+1:length(densitytmp)+offset+1)=densitytmp;
end
end
imagesc(dorsal_1bin<-.04);
assignin('base','dorsal_1bin',dorsal_1bin);


    