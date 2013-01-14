function [Points,Areas,Volumes,Centroids]=RetrogradeOverlap(xy_res,z_res,tissue_string,rthresh,gthresh)
% This function takes two stacks of tiff images of either cortical
% injection sites or LGN projection zones and computes the number of
% objects found in each of the image stacks as well as the overlap between
% the images in terms of area and volume.  For each image in the stacks, an
% area is computed taking the convex hull of objects which are found to be
% above a calculated brightness threshold.  The intersection of the two
% convex hulls is taken as the area of overlap between the the two
% injection sites represented in the input images.  The volume of the
% 3D convex hull from each image stack is then computed and the overlap
% between the two is reported.
%
% USAGE
% [Points,Areas,Volumes]=RetrogradeOverlap(xy_res,z_res,tissue_string)
%
% VARIABLE DEFINITIONS
% Points - a structure containing the X,Y, and Z locations of all the found
%          points in the the supplied red and green image stacks.  The
%          Points structure consists of X.g, X.r, Y.g, Y.r, Z.g, and Z.r
%          fields where .r and .g are in turn the subfields refferring to
%          the coordinates in the red and green image stacks
% Areas -  a structure containing the area information computed. Th Areas
%          stucture consists of .SliceX_Green, .SliceX_Red, and
%          .SliceX_Overlap substructures for each slice, where X is the
%          slicenumber that the substructures refer to
% Volumes - a stucture containing the Volume of the red and green images as
%          well as the overlap volume between them.  The Volumes stucture
%          contains .Green, .Red, and .Overlap subfields which refer to the
%          above volume measures.
% Centroids - a sturcture containing the Centroids for the red and green
%             images.  The strucure contains .Red and .Green subfields which 
%             refer to the centoir measurement in the red and green channel, 
%             respectively.  Additionally, the structure contains a
%             subfield .Dist which is the euclidean distance between the
%             red and green centroids.
% xy_res - the resolution in µm/pixel of the images in the xy plane
% z_res - the resolution in µm/pixel of the images in z
% tissue_string - a string with the value of either 'ctx' or 'lgn' used to
%                 specify which tissue type is being analyzed


% Collect points from the two image stacks and return their X, Y, and Z
% locations

%carry out the appropriate analysis based on tissue_string
switch lower(tissue_string)
    case 'ctx'
    %cortical processing code
    [X,Y,Z,breaks,path,file]=tiff_multi_reconstruct(xy_res,z_res,0,'ctx',rthresh,gthresh);
    filetok=strtok(file,'.');
    [Areas,Volumes]=getCtxData(X,Y,Z,breaks,xy_res,path,filetok);
    case 'lgn'
    %LGN processing code
    [X,Y,Z,breaks,path,file]=tiff_multi_reconstruct(xy_res,z_res,0,'lgn',rthresh,gthresh);
    filetok=strtok(file,'.');
    [Areas,Volumes]=getCtxData(X,Y,Z,breaks,xy_res,path,filetok);
end

%build the output stucture and format data in µm. 
Points.X.g=X.g*xy_res;
Points.Y.g=Y.g*xy_res;
Points.Z.g=Z.g*xy_res;
Points.X.r=X.r*xy_res;
Points.Y.r=Y.r*xy_res;
Points.Z.r=Z.r*xy_res;

%write Areas data to an excel file
for N=1:length(breaks.g)-1
    eval(sprintf('xlstmp(%g,1)=Areas.Slice%g_Green;',N,N));
    eval(sprintf('xlstmp(%g,2)=Areas.Slice%g_Red;',N,N));
    eval(sprintf('xlstmp(%g,3)=Areas.Slice%g_Overlap;',N,N));
end
xlswrite(sprintf('%s/%sAreas.csv',path,filetok),xlstmp);
clear xlstmp;
xlstmp(1,1)=Volumes.Green;
xlstmp(1,2)=Volumes.Red;
xlswrite(sprintf('%s/%sVolumes.csv',path,filetok),xlstmp);

%calculate the centroids for the red and green channel and compute the
%euclidean distance between the two.
Centroids.Red=[mean(Points.X.r),mean(Points.Y.r),mean(Points.Z.r)];
Centroids.Green=[mean(Points.X.g),mean(Points.Y.g),mean(Points.Z.g)];
Centroids.Dist=sqrt((Centroids.Red(1)-Centroids.Green(1))^2+...
    (Centroids.Red(2)-Centroids.Green(2))^2+...
    (Centroids.Red(3)-Centroids.Green(3))^2);
    



%save the current workspace
save(sprintf('%s/%sRetrogradeWorkspace.mat',path,filetok));
end

function [Areas,Volumes]=getCtxData(X,Y,Z,breaks,xy_res,path,filetok)
for N=2:length(breaks.g)
    %compute the convex hull and area of the green injection data for each 
    %slice
    sliceRange=sum(breaks.g(1:N-1)):sum(breaks.g(2:N));
    if breaks.g(N)>2
        Xgtmp=X.g(sliceRange);
        Ygtmp=Y.g(sliceRange);
        [kg2,ag]=convhull(Xgtmp,Ygtmp);
    else
        ag=0;
    end
    
    %compute the convex hull and area of the red injection data for each 
    %slice
    sliceRange=sum(breaks.r(1:N-1)):sum(breaks.r(2:N));
    if breaks.r(N)>2
        Xrtmp=X.r(sliceRange);
        Yrtmp=Y.r(sliceRange);
        [kr2,ar]=convhull(Xrtmp,Yrtmp);
    else
        ar=0;
    end
    
    %compute the overlap between the red and green injections for each
    %slice
    if ar~=0 && ag~=0
        bwim=zeros(max(cat(1,Xgtmp,Xrtmp)),max(cat(1,Ygtmp,Yrtmp)));
        maskg=roipoly(bwim,Ygtmp(kg2),Xgtmp(kg2));
        maskr=roipoly(bwim,Yrtmp(kr2),Xrtmp(kr2));
        overlapim=maskg+maskr;
        [Xo,Yo]=find(overlapim==2);
        if length(Xo)>2
            [ko2,ao]=convhull(Xo,Yo);
        else
            ao=0;
        end
    else
        ao=0;
    end
    %build the slice area output structure for each slice and format in µm
    eval(sprintf('Areas.Slice%g_Green=%g;',N-1,ag*xy_res));
    eval(sprintf('Areas.Slice%g_Red=%g;',N-1,ar*xy_res));
    eval(sprintf('Areas.Slice%g_Overlap=%g;',N-1,ao*xy_res));
end
%compute the 3D convex hull and volume of the green injection
gflag=length(X.g)>3;
rflag=length(X.r)>3;
figure;title('3D convex hull');
if gflag==1   
    G=cat(2,X.g,Y.g,Z.g);
    [kg3,vg]=convhulln(G);
    plot3(G(:,1),G(:,2),G(:,3),'.g');hold on;
    trisurf(kg3,G(:,1),G(:,2),G(:,3),'FaceColor',[0 1 0],'FaceAlpha',.5);
    Volumes.Green=vg*xy_res;
else
    Volumes.Green=0;
        disp('Not Enough points for convex hull calculations in the green channel');
end
if rflag==1;
    R=cat(2,X.r,Y.r,Z.r);
    [kr3,vr]=convhulln(R);
    plot3(R(:,1),R(:,2),R(:,3),'.r');
    trisurf(kr3,R(:,1),R(:,2),R(:,3),'FaceColor',[1 0 0],'FaceAlpha',.5);
    Volumes.Red=vr*xy_res;
else
    Volumes.Red=0;
    disp('Not Enough points for convex hull calculations in the red channel');
end
hold off;
set(gcf,'Color','k');
axis equal;
axis vis3d;
axis off;
%save an image of the 3D figure;
f=getframe(gcf);
imwrite(f.cdata,sprintf('%s/%s3DReconstruction.jpg',path,filetok));

%compute the convex hulls of the 2D z projection of the 3D volumes and
%display them along with the z projections
figure;title('2D convex hull');
if gflag==1
    kg2=convhull(X.g,Y.g);
    hold on;
    plot(X.g,Y.g,'.g');
    plot(X.g(kg2),Y.g(kg2),'-g');
end
if rflag==1
    kr2=convhull(X.r,Y.r);
    plot(X.r,Y.r,'.r');
    plot(X.r(kr2),Y.r(kr2),'-r');
end
hold off;
axis square;
%save an image of the 2D figure;
f=getframe(gcf);
imwrite(f.cdata,sprintf('%s/%s2DReconstruction.jpg',path,filetok));

end

function [Areas,Volumes]=getLgnData(X,Y,Z,breaks)
end

%Version: 1.0
%Corey J. Flynn
%Laboratory of Justin Crowley
%Department of Biological Sciences
%Carnegie Mellon University
%Contact: cjflynn@andrew.cmu.edu
