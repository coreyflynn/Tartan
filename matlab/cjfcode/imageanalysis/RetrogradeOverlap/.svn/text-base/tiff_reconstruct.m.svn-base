function [X,Y,Z,breaks]=tiff_reconstruct(varargin)
% This function takes either a stack of alligned tiff images or an existing
% 3D matrix from the workspace and reconstructs the 3D volume of points
% that fall above a given treshold value.
% 
% USAGE
% [X,Y,Z,breaks]=tiff_reconstruct - Prompts the user to navigate to a stacked tiff file
% and operates on the file using the default values of xy_res=1, z_res=50,
% threshold=.85*(current image max).
% 
% [X,Y,Z,breaks]=tiff_reconstruct(xy_res,z_res) - Prompts the user to navigate to a stacked 
% tiff file and operates on the file using the given resolution vaues and the
% default threshold value of .85*(current image max)
% 
% [X,Y,Z,breaks]=tiff_reconstruct(xy_res,z_res,tiffstack) - Operates on the provided 3D 
% matrix in tiffstack with the provided resolution values and the default 
% threshold value of .85*(current image max)
% 
% [X,Y,Z,breaks]=tiff_reconstruct(xy_res,z_res,tiffstack,threshold) - Operates on the
% provided 3D matrix in tiffstack with the provided resolution values at the
% provided threshold.
% 
% [X,Y,Z,breaks]=tiff_reconstruct(xy_res,z_res,tiffstack,threshold,m_size) - Operates on the
% provided 3D matrix in tiffstack with the provided resolution values at the
% provided threshold.  Additionally, a 3D plot of the data is generated with 
% the given marker size.
% 
% VARIABLE DEFINITIONS
% 
% X - the x coordinates of the reconstructed pixels
% Y - the y coordinates of the reconstructed pixels
% Z - the z coordinates of the reconstructed pixels
% breaks - the number of points in the X,Y,and Z data series that fall in
%          each sequential image analyzed.  The first entry in breaks is 1
%          in order to facilitate later use of the variable in higher level
%          functions.  All later entries into breaks are real data
% xy_res - the resolution in µm/pixel of the images in the xy plane
% z_res - the resolution in µm/pixel of the images in z
% tiffstack - the stack of images to be reconstructed
% threshold - the pixel value above which the reconstuction will be carried 
%             out
% m_size - the size of the markers to be used in the generated 3D plot.
% 

%parse input values
switch nargin
    case 0
    [file,path]=uigetfile({'*.tif';'*.tiff'},'Select Tiff Stack','~/Desktop');
    tiffstack=tiffread2(sprintf('%s%s',path,file));
    for N=1:length(tiffstack)
        tmpstack(:,:,N)=tiffstack(N).data;
    end
    tiffstack=tmpstack;
    xy_res=1;
    z_res=50;
    thresh_flag=1;
    marker_flag=1;
    case 2
    [file,path]=uigetfile({'*.tif';'*.tiff'},'Select Tiff Stack','~/Desktop');
    tiffstack=tiffread2(sprintf('%s%s',path,file));
    for N=1:length(tiffstack)
        tmpstack(:,:,N)=tiffstack(N).data;
    end
    tiffstack=tmpstack;
    xy_res=varargin{1};
    z_res=varargin{2};
    thresh_flag=1;
    marker_flag=1;
    case 3
    tiffstack=varargin{3};
    xy_res=varargin{1};
    z_res=varargin{2};
    thresh_flag=1;
    marker_flag=1;
    case 4
    tiffstack=varargin{3};
    xy_res=varargin{1};
    z_res=varargin{2};
    threshold=varargin{4};
    thresh_flag=0;
    marker_flag=1;
    case 5
    tiffstack=varargin{3};
    xy_res=varargin{1};
    z_res=varargin{2};
    threshold=varargin{4};
    m_size=varargin{5};
    thresh_flag=0;
    marker_flag=0;
end
    


% calculate the number of slices in the stack
slength=size(tiffstack,3);

% calculate the appropriate spacing in z for the slices and the
% appropriate marker size in order to fill the volume.
z_step=z_res/xy_res;

if marker_flag==1
    m_size=z_step/3;
end

% grab points from all images falling above threshold
X=[];
Y=[];
Z=[];
breaks=1;
disp('thresholding...');
if thresh_flag==1
    for N=1:slength
    MCTThresh=MCT(tiffstack(:,:,N));
    [x,y]=find(MCTThresh.image==1);
    z=ones(length(x),1)*N*z_step;
    X=cat(1,X,x);
    Y=cat(1,Y,y);
    Z=cat(1,Z,z);
    breaks=cat(1,breaks,length(x));
    end
else
    for N=1:slength
        %tmp=tiffstack(:,:,N)>threshold;
      tmp=imopen(tiffstack(:,:,N)>threshold,strel('disk',1));
    [x,y]=find(tmp);
    z=ones(length(x),1)*N*z_step;
    X=cat(1,X,x);
    Y=cat(1,Y,y);
    Z=cat(1,Z,z);
    breaks=cat(1,breaks,length(x));
    end
end

if marker_flag==0
    fig=figure;
    disp('generating 3D plot...');
    plot3(X,Y,Z,'o','MarkerEdgeColor','r','MarkerFaceColor','r'...
        ,'MarkerSize',m_size);
    set(fig,'DoubleBuffer','on','Color','k');
    axis equal;
    axis vis3d;
    axis off;
    drawnow;
end

%Version: 1.0
%Corey J. Flynn
%Laboratory of Justin Crowley
%Department of Biological Sciences
%Carnegie Mellon University
%Contact: cjflynn@andrew.cmu.edu




