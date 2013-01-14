function c_ave=cjf_line_average(im,cr,step)
%This funciton takes a user defined line contour and calculates a moving
%average along that line.  At every point along the line, the moving
%average is calculated as the mean of all pixels that fall within a given
%radius of the point.
%
%USAGE  cjf_line_average(im,cr)
%
%VARIABLE DEFINITIONS
%im - the image to be operated on
%
%cr - circular radius to be used in the moving average calculation

%display the image and ask the user to define a countour
h=figure;
him=imagesc(im);
imscrollpanel(h,him);
imoverview(him);
immagbox(h,him);
colormap(gray);truesize;title('Define Analysis Countour');
[cx,cy,c]=improfile;
c_ave=zeros(1,length(cx));

%define the circular region of interest and output a small mask for use
%with the moving average
cmask=zeros(cr*2+1,cr*2+1);
for x=1:cr*2+1
    for y=1:cr*2+1
        if sqrt((x-cr-1)^2+(y-cr-1)^2)<=cr
            cmask(x,y)=1;
        end
    end
end
%calculate the moving average
close(h);
figure;
subplot(1,2,1);
imagesc(im);colormap(gray);
line(cx,cy);
cpoint=impoint(gca,cx(1),cy(1));
cpointapi=iptgetapi(cpoint);
iter=0;
for N=1:step:length(cx)
    iter=iter+1;
    c_ave(iter)=get_point_mean(im,cx(N),cy(N),cmask,cr,cpointapi);
    subplot(1,2,2);plot(c_ave(1:iter));drawnow;
end
close(h);
end

function c_ave=get_point_mean(im,x,y,cmask,cr,cpointapi)
    immask=zeros(size(im));
    immask(round(y-cr):round(y+cr),round(x-cr):round(x+cr))=cmask;
    c_ave=mean2(im(immask==1));
    cpointapi.setPosition(x,y);
end

