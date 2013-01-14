function out=facePointsTrack(aviPath)
%inputs an avi movie file and asks the user to select points on the image to track
%for point tracking on faces

%read a movie file in
mov=aviread(aviPath);
imagesc(mov(1).cdata);

%select a point on the image to track
firstFrame = mov(1).cdata;
[y,x,rgb] = impixel(firstFrame);
X=zeros(1,length(mov));
Y=zeros(1,length(mov));
Y=[];
X=[];
X=horzcat(X,x);
Y=horzcat(Y,y);
count=1;
for ii=2:2:length(mov)
    count=count+1
    secondFrame = mov(ii).cdata;
    [tmpy,tmpx] = getNewPos(firstFrame,secondFrame,X(count-1),Y(count-1));
    firstFrame=secondFrame;
    X=horzcat(X,tmpx);
    Y=horzcat(Y,tmpy);
imagesc(firstFrame);hold on; plot(Y(count),X(count),'+g');drawnow;
end

out=X;

function [newy,newx]=getNewPos(firstFrame,secondFrame,x,y)
c=zeros(21,21,3);
c(:,:,1) = xcorr2(double(firstFrame(y-5:y+5,x-5:x+5,1)),double(secondFrame(y-5:y+5,x-5:x+5,1)));
c(:,:,2) = xcorr2(double(firstFrame(y-5:y+5,x-5:x+5,2)),double(secondFrame(y-5:y+5,x-5:x+5,2)));
c(:,:,3) = xcorr2(double(firstFrame(y-5:y+5,x-5:x+5,3)),double(secondFrame(y-5:y+5,x-5:x+5,3)));
cTot = mean(c,3);

[yf,xf,i] = find(cTot==max(max(cTot)),1);

newy = y+(yf-11);
newx = x+(xf-11);