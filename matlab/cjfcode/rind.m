function varargout=rind(varargin)
% This function takes the optical density of a brain section along a user
% defined contour
%
% USAGE:
% INPUTS
% ...=rind(image,thickness)
%   takes the optical density of the supplied image with a user defined
%   thickness, where thickness is the distance from the contour at which
%   the optical density will be calculated.  The optical density will be
%   calculated at 10 pixel steps along the countour.
% ...=rind(image,thickness,step)
%   same as above with a user defined step thickness
% ...=rind(image,thickness,step,cx,cy)
%   same as above without the use of a user defined contour.  Instead, the
%   cx and cy are the x and y cordinates of a previously defined contour.
% ...=rind(image,thickness,step,cx,cy,density_flag)
%     same as above without the optical density measure if density_flag=0.  
%     This can be used to simply shrink a given contour line along lines 
%     perpendicular to the tangent
% OUTPUTS
% out=rind(...)
%   outputs the standard output structure with the fields:
%       cx and cy: the x and y components of the countour used for analysis
%       density: the optical density measurements taken
%       image: the image used for analysis
% [out,newcx,newcy]=rind(...)
%   outputs the standard output structure along with new x and y
%   coordinates (newcx,newcy) for the version of the analysis contour that
%   is a version of the analysis contour that has been shrunk perpendicular
%   to its tangents by a distance define in the thickness input variable

%% Parse the input arguments
if nargin==2
    image=double(varargin{1});
    thickness=double(varargin{2});
    step=10;
    h=figure;
    him=imagesc(image);
    imscrollpanel(h,him);
    imoverview(him);
    immagbox(h,him);
    colormap(gray);truesize;title('Define Edge Countour');
    [out.cx,out.cy,c]=improfile;
    density_flag=1;
elseif nargin==3
    image=double(varargin{1});
    thickness=double(varargin{2});
    step=varargin{3};
    h=figure;
    him=imagesc(image);
    imscrollpanel(h,him);
    imoverview(him);
    immagbox(h,him);
    colormap(gray);truesize;title('Define Edge Countour');
    [out.cx,out.cy,c]=improfile;
    density_flag=1;
elseif nargin==5
    image=double(varargin{1});
    thickness=double(varargin{2});
    step=varargin{3};
    out.cx=varargin{4};
    out.cy=varargin{5};
    density_flag=1;
    elseif nargin==6
    image=double(varargin{1});
    thickness=double(varargin{2});
    step=varargin{3};
    out.cx=varargin{4};
    out.cy=varargin{5};
    density_flag=varargin{5};
end

%% Take optical density measures along the specified contour and build part
%% of the output structure
count=0;
if density_flag==1
hw=waitbar(0,'Slice Progress');
for N=step+1:step:length(out.cx)-step
    waitbar(N/(length(out.cx)-step),hw,'Slice Progress');
    count=count+1;
    mask=get_tan_rect(image,out.cx,out.cy,round(N),step,thickness);
    found=find(mask==1);
    out.density(count)=mean(image(found));
    %plot(out.density(1:count));drawnow;
end
close(hw);
end

%% Define the standard output image and parse the output argument
out.image=image;
if nargout==1
    varargout{1}=out;
elseif nargout==3
    [newcx,newcy]=get_tan_line(out,thickness);

    %% delete points in the adjusted contour that create loops
    emptyflag=0;
        shiftedcx=circshift(newcx,[1 0]);
        shiftedcy=circshift(newcy,[1 0]);
        window=(2:length(newcx)-1);
        out.eudist=sqrt((newcx(window)-shiftedcx(window)).^2+...
        (newcy(window)-shiftedcy(window)).^2);
        found=find(out.eudist>10);
        emptyflag=isempty(found);
        if emptyflag==0
        for N=1:length(found)
        newcx(found(N)-round(thickness/2):found(N)+round(thickness/2))=newcx(found(N));
        newcy(found(N)-round(thickness/2):found(N)+round(thickness/2))=newcy(found(N));
        end
        end
        
        
        % fill out a pixel level catalog of the points in the shunken
        % countour defined by newcx and newcy.
        [newcx,newcy,c]=improfile(image,newcx,newcy);
    %%
    varargout{1}=out;
    varargout{2}=newcx;
    varargout{3}=newcy;
end



%% This function handles the mechanics of taking a single optical density
%% measure
function [mask,newcx,newcy]=get_tan_rect(image,cx,cy,pos,bin_size,thickness)
half_bin=round(bin_size/2);
Y=[cy(pos+half_bin) cy(pos-half_bin)];
X=[cx(pos+half_bin) cx(pos-half_bin)];
ang=atan2(Y(1)-Y(2),X(1)-X(2));
newX=X+cos(ang+deg2rad(90))*thickness;
newY=Y+sin(ang+deg2rad(90))*thickness;
mask=roipoly(image,[X(1),X(2),newX(2),newX(1)],[Y(1),Y(2),newY(2),newY(1)]);
% imagesc(mask.*image);
% line(cx,cy);
end

function [newcx,newcy]=get_tan_line(out,thickness)
    shiftcx=circshift(out.cx,[1 0]);
    shiftcy=circshift(out.cy,[1 0]);
    ang=atan2(out.cy-shiftcy,out.cx-shiftcx);
    newcx=out.cx+cos(ang+deg2rad(90))*thickness;
    newcy=out.cy+sin(ang+deg2rad(90))*thickness;
    newcx(1)=[];
    newcy(1)=[];
end
end