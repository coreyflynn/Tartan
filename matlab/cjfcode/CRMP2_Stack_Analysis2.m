function CRMP2_Stack_Analysis2(varargin)
% read in a pre-aligned tiff stack to operate on unless one is given by the
% user
if nargin==1
    xy_res=varargin{1};
    [file,path]=uigetfile({'*.tif';'*.tiff'},'Select Tiff Stack','~/Desktop');
    tiffstack=tiffread2(sprintf('%s%s',path,file));
    width=5;
    depth=400;
elseif nargin ==2
    xy_res=varargin{1};
    tiffstack=varargin{2};
    width=5;
    depth=400;
elseif nargin ==3
    xy_res=varargin{1};
    width=varargin{2};
    depth=varargin{3};
    [file,path]=uigetfile({'*.tif';'*.tiff'},'Select Tiff Stack','~/Desktop');
    tiffstack=tiffread2(sprintf('%s%s',path,file));
elseif nargin ==4
    xy_res=varargin{1};
    tiffstack=varargin{2};
    width=varargin{3};
    depth=varargin{4};
    
else 
    disp('USAGE');
    disp('CRMP2_Stack_Analysis2(xy_res) or CRMP2_Stack_Analysis2(xy_res,tiffstack)');
    disp('or CRMP2_Stack_Analysis2(xy_res,tiffstack,window_width,window_depth)');
end


% Specify the contour to be analyzed for each image ahead of time.
cxstack={};
cystack={};
means=[];
for N=1:length(tiffstack)
    h=figure;
    try
        image=tiffstack(N).data;
    catch
        image=tiffstack(:,:,N);
    end
    him=imagesc(image);
    imscrollpanel(h,him);
    imoverview(him);
    immagbox(h,him);
    colormap(gray);truesize;
    title(sprintf('Define Edge Countour: slice %g of %g',N,length(tiffstack)));
    
    
    [cx,cy,c]=improfile;
        title(sprintf('Define Background: slice %g of %g',N,length(tiffstack)));
    means=horzcat(means,get_mean(h,image,xy_res));
    cxstack{N}=cx;
    cystack{N}=cy;
    close(h)
end

% take the optical density of a user defined contour around the pial
% surface of each slice.  The default optical density measurement is 5µm
% wide along the pial surface and 400µm into the section.
for N=1:length(tiffstack)
    tmp=tiffstack(N).data;
    disp(sprintf('Taking the optical density of image %g of %g',N,length(tiffstack)));
    slicedata=rind(double(tmp),depth/xy_res,width/xy_res,cxstack{N},cystack{N});
    slicedata.bg=means(N);
    slicedata.density_bg_corrected=slicedata.density/slicedata.bg;
    assignin('base',sprintf('slice%g',N),slicedata);
end

%funciton to do alignment of secitons
align_sections(length(tiffstack));

function out=get_mean(h,image,xy_res)
figure(h);
[y,x]=ginput(1);
out=mean2(image(x-round(50/xy_res):x+round(50/xy_res),...
    y-round(50/xy_res):y+round(50/xy_res)));
disp(out);

function align_sections(slicenum)
offset_list=[];
for N=1:slicenum
tmp1=evalin('base',sprintf('slice%g.cy',N));
tmp2=evalin('base',sprintf('slice%g.cy',slicenum));
mid=round(length(tmp1)/2);
offset=round((tmp2(mid)-tmp1(mid))/1);
offset_list=horzcat(offset_list,offset)
tmplength=length(tmp1);
densitytmp=evalin('base',sprintf('slice%g.density',N));

%optional spatial filtering
%densitytmp=cjf_band_filter(densitytmp,1,[1/20 1/10 ],0);
%optional spatial filtering


try
dorsal(N,offset+1:length(densitytmp)+offset)=densitytmp;
catch M
dorsal(N,offset+1:length(densitytmp)+offset+1)=densitytmp;
end
end
imagesc(dorsal);colormap(gray);
assignin('base','dorsal',dorsal);
assignin('base','offset',offset_list);