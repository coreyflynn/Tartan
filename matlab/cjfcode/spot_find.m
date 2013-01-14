function [spot_stats,volumes,bt,lapim]=spot_find(im,SShape,SSize)
%  This function uses the laplacian of gausian smoothed images of a set
%  of two dimensional gels to extract spot domains from the images.  After
%  extraction, spot-wise statistics are taken and reported.
%
%  USAGE
%  [spot_stats,volumes]=spot_find(SShape,SSize)
%  SShape - structuring element shape to use.  Typically 'disk' or 'square'
%  SSize - size in pixels over which to built the structuring element
%  spot_stats - a structure containing computed spot-wise statistics
%  volumes - the computed volumes of all identified spots in the image

%% Set up a gaussian and laplacian filter kernel for use in spot
%% localization
GH=fspecial('gaussian');
LH=fspecial('laplacian');

%% Apply the above filters to the input image
im=medfilt2(im);
bg=imfilter(im,GH);
lapim=(imfilter(bg,LH));
figure(1);imagesc(lapim);drawnow;
lapmin=min(lapim(:));

%% Declare a flag and iterator variable for later use
flag=1;
count=1;

%% Get an inital estimate of spot stats and a spot mask
disp('Getting intial spot location estimates...');
[spot_stats,bt]=getspots(lapim,im,count,SShape,SSize);

while flag==1
    flag=0;
    count=count+1;
    for N=1:length(spot_stats)
        x=round(spot_stats(N).BoundingBox);
        if x(3)/x(4)<=.5
            %disp(sprintf('low catch: spot #%g',N));
            tmpim=lapim(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpline=mean(tmpim,2);
            tmpmin=find(diff(tmpline)==min(diff(tmpline)));
            tmpim=bt(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpim(tmpmin,:)=0;
            %subplot(1,2,1);(imagesc(tmpim));
            bt(x(2):x(2)+x(4),x(1):x(1)+x(3))=tmpim;
            flag=1;
            %subplot(1,2,2);imagesc(tmpim)
        end
        if x(3)/x(4)>=2
            %disp(sprintf('high catch: spot #%g',N));
            tmpim=lapim(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpline=mean(tmpim,1);
            tmpmin=find(diff(tmpline)==min(diff(tmpline)));
            tmpim=bt(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpim(:,tmpmin)=0;
            %subplot(1,2,1);(imagesc(tmpim));
            bt(x(2):x(2)+x(4),x(1):x(1)+x(3))=tmpim;
            flag=1;
            %subplot(1,2,2);imagesc(tmpim);
        end
    end
    markedim=bwlabel(bt,4);
    spot_stats=regionprops(markedim);
    disp(sprintf('pass #%g found spots: %g',count,length(spot_stats)));
    btopen=~imopen(bt,strel(SShape,SSize));
    imagesc(im.*btopen);colormap(gray);drawnow;
    title(sprintf('pass #%g',count));drawnow;
end
rawspotnum=length(spot_stats);
bt=imopen(bt,strel(SShape,SSize));
imagesc(im.*~bt);colormap(gray);drawnow;
title('Final Spot Map');drawnow;
markedim=bwlabel(bt,4);
spot_stats=regionprops(markedim,im,'all');
finalspotnum=length(spot_stats);
disp(sprintf('Rejected Spot Number: %g',rawspotnum-finalspotnum));
disp(sprintf('Final Spot Number: %g',finalspotnum));
volumes=zeros(1,finalspotnum);
for N=1:finalspotnum
    volumes(N)=sum(spot_stats(N).PixelValues);
end



function [spot_stats,bestthresh]=getspots(lapim,im,count,SShape,SSize)
% This function uses an gradient descent strategy to find the best
% correlation between a binary spot mask and the given input image

%% Declare the function to be optimized and its initial parameters
corrfun= @(x) corr2(im,imopen(lapim>x(1) ,strel(SShape,round(3))));
x0=0;


%% Solve the optimization function
xopt=fminsearch(corrfun,x0,optimset('TolFun',1.e-100,'DiffMaxChange',.001));
xopt;

%% Construct the best spot mask and label all continuos image objects
bestthresh=imopen(lapim>xopt,strel(SShape,2));
%bestthresh=imopen(lapim>(-1),strel(SShape,round((2))));
markedim=bwlabel(bestthresh,4);

%% Compute spot-wise statistics and report the number of found spots 
spot_stats=regionprops(markedim);
disp(sprintf('pass #%g found spots: %g',count,length(spot_stats)));