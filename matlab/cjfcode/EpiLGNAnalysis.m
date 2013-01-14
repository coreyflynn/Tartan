function out=EpiLGNAnalysis(RGB)
%the assumption is that the ipsi channel is green 
out.RGB.Raw=RGB;

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

%get rid of small blobs
Ropen=imopen(Rthresh.image,strel('disk',3));
Gopen=imopen(Gthresh.image,strel('disk',3));
out.Contra.Open=Ropen;
out.Ipsi.Open=Gopen;

%create an RGB image of the thresholded and opened images
out.RGB.Bi=RGB*0;
out.RGB.Bi(:,:,1)=Ropen*255;
out.RGB.Bi(:,:,2)=Gopen*255;

%calculate the percent ovelap and percent of total area for the projections
out.OverlapArea=sum(sum(Ropen.*Gopen));
out.TotalArea=sum(sum(Ropen))+sum(sum(Gopen))-out.OverlapArea;
out.PercentOverlap=out.OverlapArea/out.TotalArea*100;
out.Contra.PercentArea=sum(sum(Ropen))/out.TotalArea*100;
out.Ipsi.PercentArea=sum(sum(Gopen))/out.TotalArea*100;

%find all objects in the thresholded images
Rlabel=bwlabel(Ropen);
Glabel=bwlabel(Gopen);
out.Contra.Label=Rlabel;
out.Ipsi.Label=Glabel;

%compute shape statistics for all objects
Rstats=regionprops(Rlabel,'all');
Gstats=regionprops(Glabel,'all');
out.Contra.Stats=Rstats;
out.Ipsi.Stats=Gstats;

%grab the summed perimeter and area values and calculate their ratio
Redge=Ropen-imerode(Ropen,strel('disk',1));
Gedge=Gopen-imerode(Gopen,strel('disk',1));
out.Contra.PerimToArea=sum(sum(Redge))/sum(sum(Ropen));
out.Ipsi.PerimToArea=sum(sum(Gedge))/sum(sum(Gopen));
out.Contra.Edge=Redge;
out.Ipsi.Edge=Gedge;
out.RGB.Edge=RGB*0;
out.RGB.Edge(:,:,1)=Redge*255;
out.RGB.Edge(:,:,2)=Gedge*255;

%display output images
summaryDisplay(out);

function summaryDisplay(out)
%displays summary of analysis to command line
disp(['Found ',num2str(length(out.Ipsi.Stats)),' ipsi patches']);
disp(['Average Contra Perim/Area = ',num2str(out.Contra.PerimToArea)])
disp(['Average Ipsi Perim/Area = ',num2str(out.Ipsi.PerimToArea)])
disp(['Percent overlap = ',num2str(out.PercentOverlap)]);
disp(['Contra percent area = ',num2str(out.Contra.PercentArea)]);
disp(['Ipsi percent area = ',num2str(out.Ipsi.PercentArea)]);

figure;subplot(2,2,1);imagesc(out.RGB.Raw);title('Raw');
subplot(2,2,2);imagesc(out.RGB.Bi);title('Binary');
subplot(2,2,3);imagesc(out.RGB.Edge);title('Edges');
subplot(2,2,4);imagesc(out.Ipsi.Label);title('Ipsi Label');

