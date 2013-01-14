function out=coronal_patch_analysis(varargin)
%% Parse input
if nargin==0
    [file,path]=uigetfile({'*.jpg'},'select an image');
    image=imread(sprintf('%s/%s',path,file));
else 
    path=varargin{1};
    [file,path]=uigetfile({'*.jpg'},'select an image',path);
    image=imread(sprintf('%s/%s',path,file));
end

%% if image is RGB, flatten it
if size(image,3)==3
    image=mean(image,3);
end
image=double(image);
%% Define the pial edge contour
    h=figure;
    him=imagesc(image);
    hsp=imscrollpanel(h,him);
    imoverview(him);
    immagbox(h,him);
    hspapi=iptgetapi(hsp);
    hspapi.setMagnification(.3);
    set(h,'NumberTitle','off');
    colormap(gray);truesize;set(h,'Name','Define Edge Countour');
    [out.pia_x,out.pia_y,c]=improfile;
    line(out.pia_x,out.pia_y);
    
%% Mark individual Patches boundaries
set(h,'Name','Click Patch Bounds. Hit Enter Twice When Done');
out.patch_bounds=get_patch_bounds;

%% Compute the straight line Patch Size and the pial surface size

out.pial_ref_start=[];
out.start_depth=[];
out.pial_ref_end=[];
out.end_depth=[];
for N=1:length(out.patch_bounds.mid.x)
    [start_depth,pial_ref_start]=get_eudist_line(out.patch_bounds.start.x(N),...
            out.patch_bounds.start.y(N),out.pia_x,out.pia_y,'r',1);
    out.start_depth=horzcat(out.start_depth,start_depth);
    out.pial_ref_start=horzcat(out.pial_ref_start,pial_ref_start);
    [end_depth,pial_ref_end]=get_eudist_line(out.patch_bounds.end.x(N),...
            out.patch_bounds.end.y(N),out.pia_x,out.pia_y,'g',1);
    out.end_depth=horzcat(out.end_depth,end_depth);
    out.pial_ref_end=horzcat(out.pial_ref_end,pial_ref_end);
end
out.straight_patch_size=sqrt(...
    (out.patch_bounds.start.x-out.patch_bounds.end.x).^2+...
    (out.patch_bounds.start.y-out.patch_bounds.end.y).^2);
out.pial_patch_size=abs(out.pial_ref_end-out.pial_ref_start);

%% For all Patches, Compute the nearest point along the Pial contour from
%% the middle of the patch and store that depth measure for each patch
out.mid_depth=[];
out.pial_ref_mid=[];
for N=1:length(out.patch_bounds.mid.x)
        [mid_depth,pial_ref_mid]=get_eudist_line(out.patch_bounds.mid.x(N),...
            out.patch_bounds.mid.y(N),out.pia_x,out.pia_y,'y',1);
        out.mid_depth=horzcat(out.mid_depth,mid_depth);
        out.pial_ref_mid=horzcat(out.pial_ref_mid,pial_ref_mid);
end

%% Compute the average depth of all patches and and compute a new contour
%% line that mirrors the pial contour at the average depth of all the
%% patches
out.ave_depth=mean(out.mid_depth);
[rindoutput,out.shrunk_pia_x,out.shrunk_pia_y]=rind...
    (image,round(out.ave_depth),1,out.pia_x,out.pia_y,0);
line(out.shrunk_pia_x,out.shrunk_pia_y,'Color','r');drawnow;

%% Compute patch sizes along the shrunken contour and compute the patch
%% peak based on a median filtered version of the patch profile along that
%% contour.
out.shrunk_patch_size=[];
out.shrunk_patch_peak_x=[];
out.shrunk_patch_peak_y=[];
out.shrunk_ref_start=[];
out.shrunk_ref_end=[];
out.line_patch_peak_x=[];
out.line_patch_peak_y=[];
for N=1:length(out.patch_bounds.mid.x)
    %shrink the pial contour to the appropriate patch depth
    [rindoutput,tmp_x,tmp_y]=rind...
    (image,round(out.mid_depth(N)),1,out.pia_x,out.pia_y,0);
    %euclidean distance from the start of the patch
    [start_depth,shrunk_ref_start]=get_eudist_line(out.patch_bounds.start.x(N),...
            out.patch_bounds.start.y(N),tmp_x,tmp_y,'r',1);
    out.shrunk_ref_start=horzcat(out.shrunk_ref_start,shrunk_ref_start);
    %euclidean distance from the end of the patch
    [end_depth,shrunk_ref_end]=get_eudist_line(out.patch_bounds.end.x(N),...
            out.patch_bounds.end.y(N),tmp_x,tmp_y,'g',1);
    out.shrunk_ref_end=horzcat(out.shrunk_ref_end,shrunk_ref_end);
    line(tmp_x,tmp_y);drawnow;
    %compute shrunken patch size
    patch_diff_listx=diff(tmp_x(shrunk_ref_start:shrunk_ref_end));
    patch_diff_listy=diff(tmp_y(shrunk_ref_start:shrunk_ref_end));
    diff_eudist=sqrt(patch_diff_listx.^2+patch_diff_listy.^2);
    tmp_patch_size=sum(diff_eudist);
    out.shrunk_patch_size=horzcat(out.shrunk_patch_size,tmp_patch_size);
    %compute patch peak based on contour pixel values
    [shrunk_patch_peak_x,shrunk_patch_peak_y]=get_patch_peak(image,...
        tmp_x(shrunk_ref_start:shrunk_ref_end),...
        tmp_y(shrunk_ref_start:shrunk_ref_end));
   hold on;
   plot(shrunk_patch_peak_x,shrunk_patch_peak_y,'yd');drawnow;
   hold off;
    out.shrunk_patch_peak_x=horzcat...
        (out.shrunk_patch_peak_x,shrunk_patch_peak_x);
    out.shrunk_patch_peak_y=horzcat...
        (out.shrunk_patch_peak_y,shrunk_patch_peak_y);

%% Compute the patch peak based on a median filtered version of patch
%% pixel values along the straight line patch definition
   [line_patch_peak_x,line_patch_peak_y]=get_patch_peak(image,...
        [out.patch_bounds.start.x(N) out.patch_bounds.end.x(N)],...
        [out.patch_bounds.start.y(N) out.patch_bounds.end.y(N)]);
   hold on;
   plot(line_patch_peak_x,line_patch_peak_y,'ys');drawnow;
   hold off;
   out.line_patch_peak_x=horzcat...
        (out.line_patch_peak_x,line_patch_peak_x);
   out.line_patch_peak_y=horzcat...
        (out.line_patch_peak_y,line_patch_peak_y);
end
%% Compute the Peak to Peak spacing along straight lines from all three of
%% the patch peak measures (midpoint, straight line peak, shrunken countour
%% peak).
out.line_mid_p2p=[];
out.line_linedense_p2p=[];
out.line_shrunkdense_p2p=[];
if length(out.patch_bounds.mid.x)>1
    for N=1:length(out.patch_bounds.mid.x)-1
        line_mid_p2p=get_eudist...
            ([out.patch_bounds.mid.x(N) out.patch_bounds.mid.x(N+1)],...
            [out.patch_bounds.mid.y(N) out.patch_bounds.mid.y(N+1)]);
        line_linedense_p2p=get_eudist...
            ([out.line_patch_peak_x(N) out.line_patch_peak_x(N+1)],...
            [out.line_patch_peak_y(N) out.line_patch_peak_y(N+1)]);
        line_shrunkdense_p2p=get_eudist...
            ([out.shrunk_patch_peak_x(N) out.shrunk_patch_peak_x(N+1)],...
            [out.shrunk_patch_peak_y(N) out.shrunk_patch_peak_y(N+1)]);
        out.line_mid_p2p=horzcat(out.line_mid_p2p,line_mid_p2p);
        out.line_linedense_p2p=horzcat(out.line_linedense_p2p,line_linedense_p2p);
        out.line_shrunkdense_p2p=horzcat(out.line_shrunkdense_p2p,line_shrunkdense_p2p);
    end
end
%% Compute the Peak to Peak spacing along the average shruken contour
%% from all three of the patch peak measures (midpoint, straight line peak,
%% shrunken countour peak).
out.shrunk_mid_p2p=[];
out.shrunk_linedense_p2p=[];
out.shrunk_shrunkdense_p2p=[];
out.shrunk_line_p2p_ref_start=[];
out.shrunk_line_p2p_ref_end=[];
out.shrunk_linedense_p2p_ref_start=[];
out.shrunk_linedense_p2p_ref_end=[];
out.shrunk_shrunkdense_p2p_ref_start=[];
out.shrunk_shrunkdense_p2p_ref_end=[];
if length(out.patch_bounds.mid.x)>1
    for N=1:length(out.patch_bounds.mid.x)-1
        [depth,shrunk_line_p2p_ref_start]=get_eudist_line(...
            out.patch_bounds.mid.x(N),out.patch_bounds.mid.y(N),...
            out.shrunk_pia_x,out.shrunk_pia_y,'y',1);
        [depth,shrunk_line_p2p_ref_end]=get_eudist_line(...
            out.patch_bounds.mid.x(N+1),out.patch_bounds.mid.y(N+1),...
            out.shrunk_pia_x,out.shrunk_pia_y,'y',1);
        out.shrunk_line_p2p_ref_start=horzcat(out.shrunk_line_p2p_ref_start,...
            shrunk_line_p2p_ref_start);
        out.shrunk_line_p2p_ref_end=horzcat(out.shrunk_line_p2p_ref_end,...
            shrunk_line_p2p_ref_end);
        out.shrunk_mid_p2p=horzcat(out.shrunk_mid_p2p,...
            abs(shrunk_line_p2p_ref_start-shrunk_line_p2p_ref_end));
        
        [depth,shrunk_linedense_p2p_ref_start]=get_eudist_line(...
            out.shrunk_patch_peak_x(N),out.shrunk_patch_peak_y(N),...
            out.shrunk_pia_x,out.shrunk_pia_y,'y',1);
        [depth,shrunk_linedense_p2p_ref_end]=get_eudist_line(...
            out.shrunk_patch_peak_x(N+1),out.shrunk_patch_peak_y(N+1),...
            out.shrunk_pia_x,out.shrunk_pia_y,'y',1);
        out.shrunk_linedense_p2p_ref_start=horzcat(out.shrunk_linedense_p2p_ref_start,...
            shrunk_linedense_p2p_ref_start);
        out.shrunk_linedense_p2p_ref_end=horzcat(out.shrunk_linedense_p2p_ref_end,...
            shrunk_linedense_p2p_ref_end);
        out.shrunk_linedense_p2p=horzcat(out.shrunk_linedense_p2p,...
            abs(shrunk_linedense_p2p_ref_start-shrunk_linedense_p2p_ref_end));
        
        [depth,shrunk_shrunkdense_p2p_ref_start]=get_eudist_line(...
            out.line_patch_peak_x(N),out.line_patch_peak_y(N),...
            out.shrunk_pia_x,out.shrunk_pia_y,'y',1);
        [depth,shrunk_shrunkdense_p2p_ref_end]=get_eudist_line(...
            out.line_patch_peak_x(N+1),out.line_patch_peak_y(N+1),...
            out.shrunk_pia_x,out.shrunk_pia_y,'y',1);
        out.shrunk_shrunkdense_p2p_ref_start=horzcat(out.shrunk_shrunkdense_p2p_ref_start,...
            shrunk_shrunkdense_p2p_ref_start);
        out.shrunk_shrunkdense_p2p_ref_end=horzcat(out.shrunk_shrunkdense_p2p_ref_end,...
            shrunk_shrunkdense_p2p_ref_end);
        out.shrunk_shrunkdense_p2p=horzcat(out.shrunk_shrunkdense_p2p,...
            abs(shrunk_shrunkdense_p2p_ref_start-shrunk_shrunkdense_p2p_ref_end));
    end
end

%% Label all patches and spaces
patch_count=0;
if nargin==3
    patch_labels=varargin{2};
else
    patch_labels=1:10;
end
for N=1:length(out.patch_bounds.mid.x);
    [depth,ref]=get_eudist_line(out.patch_bounds.mid.x(N),...
        out.patch_bounds.mid.y(N),out.pia_x,out.pia_y,'y',0);
    patch_count=patch_count+1;
    text(out.pia_x(ref),out.pia_y(ref),sprintf('Patch %g',...
        patch_labels(patch_count)),'FontSize',20);
end
space_count=0;
if nargin==3
    space_labels=varargin{3};
else
    space_labels=1:10;
end
for N=1:length(out.patch_bounds.mid.x)-1
    ref=round(out.shrunk_shrunkdense_p2p_ref_start(N)...
        +out.shrunk_shrunkdense_p2p(N)/2);
    space_count=space_count+1;
    text(out.shrunk_pia_x(ref),out.shrunk_pia_y(ref),sprintf('Space %g',...
        space_labels(space_count)),'FontSize',20);
end

%% compute the segregation index (SI) for each patch. 
out.patch_intensity=[];
out.interpatch_intensity=[];
out.SI=[];
if length(out.shrunk_patch_size)>1
    imageInvert=-image+max(image(:));
    for N=1:length(out.shrunk_patch_size)
        tmpMean=getWindowMean(imageInvert,out.shrunk_patch_peak_x(N),...
            out.shrunk_patch_peak_y(N),200);
        out.patch_intensity=horzcat(out.patch_intensity,tmpMean);
    end

    for N=1:length(out.shrunk_mid_p2p)
        ref=round(out.shrunk_shrunkdense_p2p_ref_start(N)...
            +out.shrunk_shrunkdense_p2p(N)/2);
        tmpMean=getWindowMean(imageInvert,out.shrunk_pia_x(ref),out.shrunk_pia_y(ref),...
            200);
        out.interpatch_intensity=horzcat(out.interpatch_intensity,tmpMean);
    end
    set(h,'Name','Select Tissue Background');
    [x1,y1]=ginput(1);
    x1=round(x1);
    y1=round(y1);
    out.tissue_bg=getWindowMean(imageInvert,x1,y1,200);
    numpatch=length(out.patch_intensity);
    for N=1:numpatch
        switch N
            case 1
                P=out.patch_intensity(N)-out.tissue_bg;
                I=out.interpatch_intensity(N)-out.tissue_bg;
                SI=1-(I/P);
            case numpatch
                P=out.patch_intensity(N)-out.tissue_bg;
                I=out.interpatch_intensity(N-1)-out.tissue_bg;
                SI=1-(I/P);
            otherwise
                P=out.patch_intensity(N)-out.tissue_bg;
                I=(out.interpatch_intensity(N-1)...
                    +out.interpatch_intensity(N))/2-out.tissue_bg;
                SI=1-(I/P);
        end
        out.SI=horzcat(out.SI,SI);
    end
end
%% Output a summary results table in a new figure
figure('Position',[100 100 500 500]);
title('results');
t1=uitable('Position',[1 1 500 250]);
t2=uitable('Position',[1 251 500 250]);
set(t1,'RowName',{'Pial Patch Size','Shrunk Patch Size','Linear Patch Size',...
    'Patch Depth','SI'});
set(t2,'RowName',{'Linear Mid p2p','Linear LineDense p2p','Linear Shrunkdense p2p',...
    'Shrunk Mid p2p','Shrunk LineDense p2p','Shrunk Shrunkdense p2p'});
set(t1,'Data',vertcat(out.pial_patch_size,out.shrunk_patch_size,...
    out.straight_patch_size,out.mid_depth,out.SI));
set(t2,'Data',vertcat(out.line_mid_p2p,out.line_linedense_p2p,...
    out.line_shrunkdense_p2p,out.shrunk_mid_p2p,out.shrunk_linedense_p2p,...
    out.shrunk_shrunkdense_p2p));

%% Save the output structure and annotated figure to memory
filetok=strtok(file,'.');
save(sprintf('%s/%s_patchAnalysis',path,filetok),'out');
F=getframe(h);
imwrite(F.cdata,sprintf('%s/%s_patchAnalysis.jpg',path,filetok));
end
function patch_bounds=get_patch_bounds
title('Define Patch Boundaries');
hold on;
button_flag=1;
patch_bounds.start.x=[];
patch_bounds.start.y=[];
patch_bounds.end.x=[];
patch_bounds.end.y=[];
patch_bounds.end.y=[];
patch_bounds.mid.x=[];
patch_bounds.mid.y=[];
while button_flag==1
    %mark the start of the patch
    [x1,y1,button_flag]=ginput(1);
    plot(x1,y1,'ro');drawnow;
    patch_bounds.start.x=horzcat(patch_bounds.start.x,x1);
    patch_bounds.start.y=horzcat(patch_bounds.start.y,y1);
    if button_flag~=1
        break
    end
    %mark the end of the patch
    [x2,y2,button_flag]=ginput(1);
    plot(x2,y2,'gs');drawnow;
    patch_bounds.end.x=horzcat(patch_bounds.end.x,x2);
    patch_bounds.end.y=horzcat(patch_bounds.end.y,y2);
    %mark the middle of the patch
    xmid=(x1+x2)/2;
    ymid=(y1+y2)/2;
    plot(xmid,ymid,'yx');drawnow; 
    patch_bounds.mid.x=horzcat(patch_bounds.mid.x,xmid);
    patch_bounds.mid.y=horzcat(patch_bounds.mid.y,ymid);
    
end
hold off;
end
function [depth,ref]=get_eudist_line(x,y,pia_x,pia_y,line_color,flag)
eudist=sqrt((x-pia_x).^2+(y-pia_y).^2);
ref=find(eudist==min(eudist),1);
depth=eudist(ref);
if flag==1
line([x pia_x(ref)],[y pia_y(ref)],'Color',line_color);drawnow;
end
end
function [peak_x,peak_y]=get_patch_peak(image,contour_x,contour_y)
[cx,cy,c]=improfile(image,contour_x,contour_y);
c=medfilt1(c,11);
found=find(c==min(c),1);
peak_x=cx(found);
peak_y=cy(found);
end
function eudist=get_eudist(X,Y)
eudist=sqrt((X(1)-X(2)).^2+(Y(1)-Y(2)).^2);
end
function windowMean=getWindowMean(image,x,y,w)
    x=round(x);
    y=round(y);
    w2=round(w/2);
    windowMean=mean2(image(y-w2:y+w2,x-w2:x+w2));
    rectangle('Position',[x-w2 y-w2 w w]);
end