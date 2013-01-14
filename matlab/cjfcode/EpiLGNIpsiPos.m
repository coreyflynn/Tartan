function out=EpiLGNIpsiPos(RGB)
%the assumption is that the ipsi channel is green 
out.RGB.Raw=RGB;
imagesc(RGB);title('select AP axis');
[cx,cy,c]=improfile;
drawAng=atan2(cx(1)-cx(end),cy(1)-cy(end))/pi*180-90;
rotAng=90-drawAng;

%apply a median filter to the data to smooth out shot noise
Rmed=medfilt2(RGB(:,:,1),[10 10]);
Gmed=medfilt2(RGB(:,:,2),[10 10]);
out.Contra.MedFilt=Rmed;
out.Ipsi.MedFilt=Gmed;

%threshold the images using MCT
Rthresh=MCT(Rmed);
Gthresh=MCT(Gmed);
out.Contra.Thresh=Rthresh.image;
out.Ipsi.Thresh=Gthresh.image;

%rotate the images
Rthresh.image=imrotate(Rthresh.image,rotAng);
Gthresh.image=imrotate(Gthresh.image,rotAng);

%get rid of small blobs
Ropen=imopen(Rthresh.image,strel('disk',3));
Gopen=imopen(Gthresh.image,strel('disk',3));
out.Contra.Open=Ropen;
out.Ipsi.Open=Gopen;

%create an RGB image of the thresholded and opened images
rotRGB=imrotate(RGB,rotAng);
out.RGB.Bi=rotRGB*0;
out.RGB.Bi(:,:,1)=Ropen*255;
out.RGB.Bi(:,:,2)=Gopen*255;
imagesc(out.RGB.Bi);drawnow;

%find all objects in the thresholded images
Rlabel=bwlabel(Ropen);
Glabel=bwlabel(Gopen);
out.Contra.Label=Rlabel;
out.Ipsi.Label=Glabel;

%compute shape statistics for all objects
Rstats=regionprops(Rlabel,'centroid','Area');
Gstats=regionprops(Glabel,'centroid','Area');
out.Contra.Stats=Rstats;
out.Ipsi.Stats=Gstats;

%find the overall centroid for the Ipsi projection weighted by percent mass
%of the ipsi projection
cWeight=[];
a=[];
for ii=1:length(Gstats)
	a=vertcat(a,Gstats(ii).Area);
	cWeight=vertcat(cWeight,Gstats(ii).Centroid*Gstats(ii).Area);
end

aTot=sum(a);

ipsiCentroid=sum(cWeight)/aTot;
out.Ipsi.Centroid=ipsiCentroid;
hold on;
title('select AP axis');drawnow;
[APx,APy,c]=improfile;
line(APx,APy);
title('select ML axis');drawnow;
[MLx,MLy,c]=improfile;
line(MLx,MLy);
plot(ipsiCentroid(1),ipsiCentroid(2),'.b');

A=max(APy);
P=min(APy);
L=max(MLx);
M=min(MLx);

APPosNorm=(ipsiCentroid(2)-P)/(A-P)
MLPosNorm=(ipsiCentroid(1)-M)/(L-M)