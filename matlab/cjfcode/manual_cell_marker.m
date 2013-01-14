function [x,y]=manual_cell_marker(im,x,y)
if nargin==1
    varargin{1}=im;
    h=figure;
    him=imagesc(im);
    imscrollpanel(h,him);
    imoverview(him);
    immagbox(h,him);
    colormap(gray);
    hold on;
    x=[];
    y=[];
elseif nargin==3
    varargin{1}=im;
    varargin{2}=x;
    varargin{3}=y;
    h=figure;
    him=imagesc(im);
    imscrollpanel(h,him);
    imoverview(him);
    immagbox(h,him);
    colormap(gray);
    hold on;
    plot(x,y,'ro');
end

flag=1;
while flag==1
    [xi,yi,flag]=ginput(1);
    plot(xi,yi,'ro');drawnow;
    x=horzcat(x,xi);
    y=horzcat(y,yi);
end
hold off;