function [Cy3,Cy5,ratios,diffs,markedim]=DIGE_analysis(varargin)
%This function imports two .dvi images files (one each for the CY3 and Cy5 channel of a 
%DIGE imaging experiment).  The images are searched for putative protein spot locations 
%and those locations are compared across both images.  From these comparisons, protein spots
%that differ from the mean by a specified amount are isolated and displayed in an output image.
%Additional spot-wise statistics are retuned for both images are well as information related
%to the ratios that are calculated
%
%USAGE
%[Cy3,Cy5,ratios]=DIGE_analysis or
%[Cy3,Cy5,ratios]=DIGE_analysis(Cy3im,Cy5im)
%
%VARIABLE DEFINITIONS
%Cy3 - a structure in which information about the Cy3 image is returned.  The structure has the
%	  following fields:
%	  Cy3.im - The portion of the Cy3 input image that was analyzed
%	  Cy3.spot_stats - the spot-wise statistics from spots found in the Cy3 image only
%	  Cy3.revised_stats - the spot-wise statistics from spots found in the Cy3 and Cy5 images
%	  Cy3.volumes - The Cy3 spot volumes of spots found in the Cy3 and Cy5 images
%Cy5 - a structure in which information about the Cy5 image is returned.  This structure has the
%	  same fields as those found in the Cy3 structure
%ratios - a structure in which information about the calculated Cy3/Cy5 ratios at each spot.  The 
%	     structure has the following fields:
%	     ratios.list - a list of the ratios calculated at each identified spot
%	     ratios.mean - the mean spot ratio
%	     ratios.std - the standard deviation around the mean spot ratio
%	     ratio.pos_sig - the index to ratios.list at which spots with large ratios can be found
%   	     ratio.neg_sig - the index to ratios.list at which spots with small ratios can be found


%Import the Cy3 and Cy5 .dvi images to be analyzed if no images are given
%as input
if nargin==0
    [file,imdir]=uigetfile({'*.dvi'},'Select The Cy3 Gel Image'...
   ,pwd);
Cy3.im=log(double(DVI_read(sprintf('%s%s',imdir,file))));
Cy3.im=max(Cy3.im(:))-Cy3.im;

[file,imdir]=uigetfile({'*.dvi'},'Select The Cy5 Gel Image'...
   ,imdir);
Cy5.im=log(double(DVI_read(sprintf('%s%s',imdir,file))));
Cy5.im=max(Cy5.im(:))-Cy5.im;
end
if nargin==2
    Cy3.im=log(double(varargin{1}));
    Cy5.im=log(double(varargin{2}));
    Cy3.im=max(Cy3.im(:))-Cy3.im;
    Cy5.im=max(Cy5.im(:))-Cy5.im;
end
   

% apply a illumination backgound correction
disp('applying fermi filters');
Cy5.origim=Cy5.im;
Cy3.origim=Cy3.im;
Cy5.im=DIGEFermi(Cy5.im);
Cy3.im=DIGEFermi(Cy3.im);



%display the Cy5 image and crop both images to a ROI for analysis
imagesc(Cy5.origim);colormap(gray);title('Select Processing ROI');
[Cy5.origim,rect]=imcrop;
Cy3.origim=imcrop(Cy3.origim,rect);
Cy5.im=imcrop(Cy5.im,rect);
Cy3.im=imcrop(Cy3.im,rect);


%find spot locations and compute first-pass statistics on both images independently
[Cy3.spot_stats,Cy3.volumes,Cy3.bt,Cy3.lapim]=spot_find(Cy3.im,'disk',1);

[Cy5.spot_stats,Cy5.volumes,Cy5.bt,Cy5.lapim]=spot_find(Cy5.im,'disk',1);

%combine the images used for spot localization and error-checking from the Cy3 and Cy5
%images into a composite image.  These images will be used to define a master spot image.
lapim=Cy3.lapim+Cy5.lapim;
bt=(Cy3.bt+Cy5.bt)>0;

%number each spot in the composite spot image and compute first pass statistics on that image
markedim=bwlabel(bt,4);
spot_stats=regionprops(markedim);

%set up a few variables used in error checking bleow
flag=1;
count=1;
SShape='disk';
SSize=1;

%check the spot image for errors.  Here errors are defined unlikely spot shapes.  Spots that
%have a major axis of their shape 2x or larger than their minor axis are isolated for boundry 
%revision.  The boundry revision searches for a minmum in the laplacian image along the axis 
%that is too long and zeros the spot image at that location in the minor axis.  This causes the
%creation on a new local spot mask.
while flag==1
    flag=0;
    count=count+1;
    for N=1:length(spot_stats)
        x=round(spot_stats(N).BoundingBox);
        if x(3)/x(4)<=.5
            tmpim=lapim(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpline=mean(tmpim,2);
            tmpmin=find(diff(tmpline)==min(diff(tmpline)));
            tmpim=bt(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpim(tmpmin,:)=0;
            bt(x(2):x(2)+x(4),x(1):x(1)+x(3))=tmpim;
            flag=1;
        end
        if x(3)/x(4)>=2
            tmpim=lapim(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpline=mean(tmpim,1);
            tmpmin=find(diff(tmpline)==min(diff(tmpline)));
            tmpim=bt(x(2):x(2)+x(4),x(1):x(1)+x(3));
            tmpim(:,tmpmin)=0;
            bt(x(2):x(2)+x(4),x(1):x(1)+x(3))=tmpim;
            flag=1;
        end
    end
    %after each round of revision, recalculate spot stats and update the displayed spot image
    markedim=bwlabel(bt,4);
    spot_stats=regionprops(markedim);
    disp(sprintf('pass #%g found spots: %g',count,length(spot_stats)));
    btopen=imopen(bt,strel(SShape,SSize));
    imagesc(btopen);colormap(gray);drawnow;
    title(sprintf('pass #%g',count));drawnow;
end

%once there are no more errorneous spots in the spot image, calculate the final stats for each
%image as well as the Cy3 and Cy5 volumes and Cy3/Cy5 ratio of each spot.
disp('Calculating Ratio and Difference Data');drawnow;
Cy3.revised_stats=regionprops(markedim,Cy3.im,'all');
Cy5.revised_stats=regionprops(markedim,Cy5.im,'all');
finalspotnum=length(Cy3.revised_stats);
Cy3.volumes=zeros(1,finalspotnum);
Cy5.volumes=zeros(1,finalspotnum);
ratios.list=zeros(1,finalspotnum);
for N=1:finalspotnum
    Cy3.volumes(N)=sum(Cy3.revised_stats(N).PixelValues);
    Cy5.volumes(N)=sum(Cy5.revised_stats(N).PixelValues);
    ratios.list(N)=Cy3.volumes(N)/Cy5.volumes(N);
    diffs.list(N)=Cy3.volumes(N)-Cy5.volumes(N);
end

%display the gel image and overlay the spot domains on the image
figure; imagesc(max(Cy5.origim(:))-Cy5.origim);colormap(gray);truesize;
title(sprintf('found %g spots',finalspotnum));hold on;
for N=1:length(Cy3.revised_stats)
        CHvertices=Cy3.revised_stats(N).ConvexHull;
        CHX=CHvertices(:,1);
        CHY=CHvertices(:,2);
        fill(CHX,CHY,'b','FaceAlpha','flat',...
            'FaceVertexAlphaData',.5,'EdgeColor','none');
end
exist('imdir')
if exist('imdir')==0
    disp('foo');
    imdir=uigetdir('Select Output Directory');
end
figure_save(gcf,imdir,'Found Spots');
%from the ratios list, calculate the mean and standard deviation.  Next, find all
%spots that fall above or below the standard deviation cutoff.
ratios.mean=mean(ratios.list);
ratios.std=std(ratios.list);
ratios.neg_sig=find(ratios.list<(ratios.mean-ratios.std*2));
ratios.pos_sig=find(ratios.list>(ratios.mean+ratios.std*2));

diffs.mean=mean(diffs.list);
diffs.std=std(diffs.list);
diffs.neg_sig=find(diffs.list<(diffs.mean-diffs.std*2));
diffs.pos_sig=find(diffs.list>(diffs.mean+diffs.std*2));

%Generate plots and save them to disk
std_line('diff',diffs);
figure_save(gcf,imdir,'Cy3 minus Cy5 Difference Magnitude');
std_line('ratio',ratios);
figure_save(gcf,imdir,'Cy3 to Cy5 Ratio Magnitude');


image_overlay(Cy3,ratios,'Cy3 Ratio');
figure_save(gcf,imdir,'Cy3 Ratio Spots');
image_overlay(Cy5,ratios,'Cy5 Ratio');
figure_save(gcf,imdir,'Cy5 Ratio Spots');
image_overlay(Cy3,diffs,'Cy3 Difference');
figure_save(gcf,imdir,'Cy3 Difference Spots');
image_overlay(Cy5,diffs,'Cy5 Difference');
figure_save(gcf,imdir,'Cy5 Difference Spots');
save(sprintf('%s/DIGEAnalysis.mat',imdir));

function image_overlay(imstruct,statstruct,titlestring)
%display the Cy5 gel image and overlay The significant Cy3 spots with red and the significant
%Cy5 spots with green. 
figure; imagesc(max(imstruct.origim(:))-imstruct.origim);colormap(gray);truesize;
title(sprintf('%s Image, Green=Cy3, Red=Cy5',titlestring));hold on;
for N=1:length(statstruct.pos_sig)
        CHvertices=imstruct.revised_stats(statstruct.pos_sig(N)).ConvexHull;
        CHX=CHvertices(:,1);
        CHY=CHvertices(:,2);
        fill(CHX,CHY,'g','FaceAlpha','flat',...
            'FaceVertexAlphaData',.5,'EdgeColor','none');
end
for N=1:length(statstruct.neg_sig)
        CHvertices=imstruct.revised_stats(statstruct.neg_sig(N)).ConvexHull;
        CHX=CHvertices(:,1);
        CHY=CHvertices(:,2);
        fill(CHX,CHY,'r','FaceAlpha','flat',...
            'FaceVertexAlphaData',.5,'EdgeColor','none');
end
hold off;

function figure_save(fig,fdir,fname)
figure(fig);
pstr=sprintf('%s/%s.jpg',fdir,fname);
print(gcf,'-djpeg',pstr);

function std_line(ftitle,statstruct)
figure;title(ftitle);
stdline=ones(1,length(statstruct.list));
stdlinep=(statstruct.mean*stdline)+statstruct.std*2;
stdlinen=(statstruct.mean*stdline)-statstruct.std*2;
plot(statstruct.list);hold on;
plot(stdlinep,'r');
plot(stdlinen,'r');
hold off


%Version: 1.0
%Corey J. Flynn
%Laboratory of Justin Crowley
%Department of Biological Sciences
%Carnegie Mellon University
%Contact: cjflynn@andrew.cmu.edu
