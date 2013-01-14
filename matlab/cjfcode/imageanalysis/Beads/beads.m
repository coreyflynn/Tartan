function out=beads(im,ROIFlag,plotFlag)
switch ROIFlag
    case 0
        %process full image
    case 1
        %set ROI
        figure;imagesc(im);colormap(gray);title('Select Processing ROI');
        im=imcrop;
    otherwise
        error('use a value of either 0(no ROI) or 1(ROI) for ROIFlag');
end
if plotFlag==1
    figure;imagesc(im);colormap(gray);title('Processing ROI');drawnow;
end
tic;
%% %pad the image and derive the maximum slope at each pixel
disp 'Calculating Gel Landscape'
padIm=padarray(im,[1 1]);
directionIm=zeros(size(im));
slopes=zeros(1,4);
for ii=2:size(im,1)
    for jj=2:size(im,2)
        slopes(1)=padIm(ii-1,jj)-padIm(ii+1,jj);
        slopes(2)=padIm(ii+1,jj)-padIm(ii-1,jj);
        slopes(3)=padIm(ii,jj-1)-padIm(ii,jj+1);
        slopes(4)=padIm(ii,jj+1)-padIm(ii,jj-1);   
        directionIm(ii,jj)=find(slopes==max(slopes),1);
    end
end
%% %roll the beads and find their endpoint as well as track their path
disp 'Rolling Beads'
beadIm=im*0;
pathIm=im*0;
directionIm=padarray(directionIm,[1 1]);
beadIm=padarray(beadIm,[1 1]);
pathIm=padarray(pathIm,[1 1]);
beadX=im*0;
beadY=im*0;
for x=2:size(im,1)+1
    for y=2:size(im,2)+1
        [beadIm,pathIm,beadx,beady]=roll(x+1,y+1,directionIm,beadIm,pathIm,30);
        beadX(x-1,y-1)=beadx-1;
        beadY(x-1,y-1)=beady-1;
    end
end

%% %build the probabilities image by overlaying 2D gaussians
%beads cutoff 
[x,y]=find(beadIm>10==1);
x=x-2;
y=y-2;

probIm=im*0;
probIm=padarray(probIm,[5,5]);
disp 'Finding Spot Centers'
for N=1:length(x)
    probIm(x(N):x(N)+10,y(N):y(N)+10)=probIm(x(N):x(N)+10,y(N):y(N)+10)...
        +gauss2(beadIm(x(N)+2,y(N)+2),.5);
end
probIm=probIm(6:size(probIm,1)-5,6:size(probIm,2)-5);
if plotFlag==1
    figure;imagesc(probIm);colormap(gray);title('Cy5 Spot Probability');drawnow;
end
%probability cutoff
probIm=probIm.*(probIm>25);
[x,y]=find(imregionalmax(probIm)==1);


%% %assign spot domains
disp 'Building Spot Domains'
domainIm=im*0;
perimIm=im*0;
domainCounter=1;
progress=20;
for N=1:length(x)
    domainImtmp=getDomain(x(N)-1,y(N)-1,beadX,beadY);
    found=domainImtmp==1;
    domainIm(found)=domainCounter;
    perimIm=perimIm+bwperim(domainImtmp,8);
    domainCounter=domainCounter+1;
    if N/length(x)*100>=progress
        disp(sprintf('---%g percent done',progress));
        progress=progress+20;
    end
end


if plotFlag==1
    figure;imagesc(im);colormap(gray);
    hold on;
    scatter(y,x,'b');
end
logim=log(im);

logimNorm=(logim-min(logim(:)))/max(max(logim-min(logim(:))));

if plotFlag==1
    RGB=zeros(size(logim,1),size(logim,2),3);
    RGB(:,:,1)=logimNorm;
    RGB(:,:,2)=logimNorm;
    RGB(:,:,3)=logimNorm;
    B=RGB(:,:,3);
    B(find(perimIm>0))=1;
    RGB(:,:,3)=B;
    figure;imagesc(RGB);hold on;
    scatter(y,x,'.b');
end

out.beadIm=beadIm;
out.beadX=beadX;
out.beadY=beadY;
out.pathIm=pathIm;
out.directionIm=directionIm;
out.spot_centerX=x;
out.spot_centerY=y;
out.domainIm=domainIm;
out.perimIm=perimIm;
out.im=im;
out.logim=logim;
out.logimNorm=logimNorm;
out.probIm=probIm;




timeElapsedSeconds=toc;
disp(sprintf('elapsed time: %i minutes, %i seconds',floor(timeElapsedSeconds/60),...
		round(mod(timeElapsedSeconds,60))));


function domainImtmp=getDomain(x,y,beadX,beadY)
try
pixX=beadX.*0;
pixY=beadX.*0;

pixX=pixX+(beadX==beadX(x,y));
pixX=pixX+(beadX==beadX(x,y)+1);
pixX=pixX+(beadX==beadX(x,y)-1);

pixY=pixY+(beadY==beadY(x,y));
pixY=pixY+(beadY==beadY(x,y)+1);
pixY=pixY+(beadY==beadY(x,y)-1);

domainImtmp=imfill((pixX>0).*(pixY>0));
catch
    domainImtmp=beadX.*0;
end


function [beadIm,pathIm,x,y]=roll(x,y,directionIm,beadIm,pathIm,steps)
for ii=1:steps
    switch directionIm(x,y)
        case 0
            break;
        case 1
            x=x-1;
        case 2
            x=x+1;
        case 3
            y=y-1;
        case 4
            y=y+1;

    end
    pathIm(x,y)=pathIm(x,y)+1;
end
beadIm(x,y)=beadIm(x,y)+1;
