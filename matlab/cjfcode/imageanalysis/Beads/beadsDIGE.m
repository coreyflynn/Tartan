function Beads=beadsDIGE(varargin)
%Import the Cy3 and Cy5 .dvi images to be analyzed
if nargin==0
	[Cy3,Cy5,imdir]=getIms;
	combinedIm=Cy3.im+Cy5.im;
elseif nargin==2
	imdir=pwd;
	Cy3.im=varargin{1};
	Cy5.im=varargin{2};
	Cy3.logim=Cy3.im;
	Cy5.logim=Cy5.im;
	combinedIm=Cy3.im+Cy5.im;
	imagesc(combinedIm);drawnow;colormap(gray)
else
	error('Wrong number of input entries.  Use either Beads=beadsDIGE or Beads=beadsDIGE(Cy3im,Cy5im)');
end
%Cy5.im=DIGEFermi(Cy5.im);
%Cy3.im=DIGEFermi(Cy3.im);
%disp('applying fermi filters');
%combinedIm=Cy3.im+Cy5.im;
%get spot domains
Beads=beads(combinedIm,0,0);

%get significant spots
spotStats=getSig(Beads,Cy3.im,Cy5.im,imdir,'SigSpots');
Beads.spotStats=spotStats;

%plot results
doPlotting(Beads,imdir,spotStats);

%export workspace to file
save(sprintf('%s/BeadsAnalysis.mat',imdir));

function [Cy3,Cy5,imdir]=getIms
[file,imdir]=uigetfile({'*.dvi'},'Select The Cy3 Gel Image'...
   ,pwd);
Cy3.im=double(DVI_read(sprintf('%s%s',imdir,file)));
Cy3.logim=log(Cy3.im);

[file,imdir]=uigetfile({'*.dvi'},'Select The Cy5 Gel Image'...
   ,imdir);
Cy5.im=double(DVI_read(sprintf('%s%s',imdir,file)));
Cy5.logim=log(Cy5.im);
%display the Cy5 image and crop both images to an ROI for analysis
figure;imagesc(Cy5.logim);colormap(gray);title('Select Processing ROI');
[Cy5.logim,rect]=imcrop;
Cy3.logim=imcrop(Cy3.logim,rect);
Cy3.im=imcrop(Cy3.im,rect);
Cy5.im=imcrop(Cy5.im,rect);
imagesc(Cy5.logim);drawnow;

function spotStats=getSig(Beads,Cy3im,Cy5im,imdir,figname)
%check spot areas
refs=1:length(Beads.spot_centerX);
pixSums=[];
for N=1:length(Beads.spot_centerX)
    found=find(Beads.domainIm==N);
    pixSums=horzcat(pixSums,length(found));
end
found=find(pixSums==0);
Beads.spot_centerX(found)=[];
Beads.spot_centerY(found)=[];
refs(found)=[];

%%find significant spots
%calculate ratios and diffs
ratios=[];
diffs=[];
Cy3spots=[];
Cy5spots=[];
for N=1:length(refs)
    found=find(Beads.domainIm==refs(N));
    ratios=horzcat(ratios,sum(Cy3im(found))/sum(Cy5im(found)));
	diffs=horzcat(diffs,sum(Cy3im(found))-sum(Cy5im(found)));
	Cy3spots=horzcat(Cy3spots,sum(Cy3im(found)));
	Cy5spots=horzcat(Cy5spots,sum(Cy5im(found)));
end


% %remove outliers
% rMean=mean(ratios);
% rStd=std(ratios,1);
% outliers=[];
% outliers=horzcat(outliers,find(ratios>(rMean+rStd*3)));
% outliers=horzcat(outliers,find(ratios<(rMean-rStd*3)));
% ratios(outliers)=[];
% %remove outliers
%find significant spots
rMean=mean(ratios);
dMean=mean(diffs);
rStd=std(ratios,1);
dStd=std(diffs,1);
posSig=find(ratios>(rMean+rStd*2));
negSig=find(ratios<(rMean-rStd*2));
hold on;
title('Significant Spots: R=Cy5, G=Cy3');
scatter(Beads.spot_centerY(posSig),Beads.spot_centerX(posSig),'g');
scatter(Beads.spot_centerY(negSig),Beads.spot_centerX(negSig),'r');
figure_save(gcf,imdir,figname);

spotStats.rMean=rMean;
spotStats.dMean=dMean;
spotStats.rStd=rStd;
spotStats.dStd=dStd;
spotStats.posSig=posSig;
spotStats.negSig=negSig;
spotStats.refs=refs;
spotStats.ratios=ratios;
spotStats.diffs=diffs
spotStats.Cy3spots=Cy3spots;
spotStats.Cy5spots=Cy5spots;

function doPlotting(Beads,imdir,spotStats)
%display overlapping spot domains on the Cy5 image
RGB=zeros(size(Beads.logim,1),size(Beads.logim,2),3);
RGB(:,:,1)=Beads.logimNorm;
RGB(:,:,2)=Beads.logimNorm;
RGB(:,:,3)=Beads.logimNorm;
B=RGB(:,:,3);
B(find(Beads.perimIm>0))=1;
RGB(:,:,3)=B;
figure;imagesc(RGB);title(sprintf('found %g spots',...
    length(Beads.spot_centerY)));hold on;
scatter(Beads.spot_centerY(spotStats.refs),Beads.spot_centerX(spotStats.refs),'.b');
figure_save(gcf,imdir,'Found Spots');
figure;imagesc(Beads.probIm);colormap(gray);title('Gel Model');
figure_save(gcf,imdir,'Gel Model');

R=RGB(:,:,1)*0;
G=R;
ratiosMeanNorm=spotStats.ratios-spotStats.rMean;
reds=ratiosMeanNorm;
reds(reds>0)=0;
rNorm=abs(reds)/max(abs(reds));
greens=ratiosMeanNorm;
greens(greens<0)=0;
gNorm=greens/max(greens);
% 
for N=1:length(spotStats.refs)
    found=find(Beads.domainIm==spotStats.refs(N));
    R(found)=(1-gNorm(N));
    G(found)=(1-rNorm(N));
end
figure;imagesc(RGB);title('Expression ratio: R=Cy5, G=Cy3');hold on;
C=zeros(length(gNorm),3);
C(:,1)=1-gNorm;
C(:,2)=1-rNorm;
scatter(Beads.spot_centerY(spotStats.refs),Beads.spot_centerX(spotStats.refs)...
    ,50,C,'filled');
figure_save(gcf,imdir,'Expression_spots');
RGB(:,:,1)=R;
RGB(:,:,2)=G;
RGB(:,:,3)=G*0;
figure;imagesc(RGB);title('Expression ratio: R=Cy5, G=Cy3');hold on;
figure_save(gcf,imdir,'Expression_filled');

%%display sorted and colored ratios
%plot
figure;h=bar(sort(spotStats.ratios),'BaseValue',spotStats.rMean);
ch=get(h,'Children');
fvd=get(ch,'Faces');
fvcd=get(ch,'FaceVertexCData');
sorted=sort(spotStats.ratios);
for i =1:length(sorted)
	fvcd(fvd(i,:)) = sorted(i);
end
set(ch,'FaceVertexCData',fvcd);
hold on;
line(1:length(sorted),(spotStats.rMean*1.5).*ones(length(sorted)),...
																'Color','k');
line(1:length(sorted),(spotStats.rMean/1.5).*ones(length(sorted)),...
																'Color','k');
hold off;
title(sprintf('ratios, mean = %f',spotStats.rMean));

%%display sorted and colored diffs

%plot
figure;h=bar(sort(spotStats.diffs),'BaseValue',spotStats.dMean);
ch=get(h,'Children');
fvd=get(ch,'Faces');
fvcd=get(ch,'FaceVertexCData');
sorted=sort(spotStats.diffs);
for i =1:length(sorted)
	fvcd(fvd(i,:)) = sorted(i);
end
set(ch,'FaceVertexCData',fvcd);
hold on;
line(1:length(sorted),(spotStats.dMean+2*spotStats.dStd).*ones(length(sorted)),...
																'Color','k');
line(1:length(sorted),(spotStats.dMean-2*spotStats.dStd).*ones(length(sorted)),...
																'Color','k');
hold off;
title('diffs');

function figure_save(fig,fdir,fname)
figure(fig);
pstr=sprintf('%s/%s.jpg',fdir,fname);
print(gcf,'-djpeg',pstr);