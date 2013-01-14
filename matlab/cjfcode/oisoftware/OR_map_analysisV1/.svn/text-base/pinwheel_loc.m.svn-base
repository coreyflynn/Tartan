function [out_pos,out_neg]=pinwheel_loc(im,rad)
%This function takes a pre-computed angle map and finds putative sites for pinwheels
%in the image. The image must be an angle map which is defined from 0? to 180?.  The  
%image is first binned into 4 equally spaced angular bins and the contours of these
%bins are then explored in order to find putative locations for pinwheel centers.
%Locations for pinwheel centers are reported for both clockwise and counter-clockwise
%pinwheels.  Pinwheels are localized by exploring small loops around pixels likely to
%be pinwheel centers.  The contour transitions in these loops are counted in order to
%determine both the presence or absence of a pinwheel and its chirality. 
%
%USAGE
%[out_pos,out_neg]=pinwheel_loc(im,rad)
%
%VARIABLE DEFINITIONS
%im - The angular prefernce map to be analyzed (must be defined from 0? to 180?)
%rad - the radius in pixels around which local contours are explored in order to 
%	  localize pinwheels
%out_pos - An image in which putative clockwise pinwheel locations are reported
%out_neg - An image in which putative counter-clockwise pinwheel locations are reported

%Set up a few variables to be used later on
imsize=size(im);
out_pos=im*0;
out_neg=im*0;
theta=linspace(0,2*pi,1000);
rho=ones(1,1000)*rad;
count=1;

%break the input map into a binned map as well as report a map of the fractures between
%the binned responses in the binned map.
[bin_im,frac]=anglemapbin(im,4);drawnow;

%Define an analysis contour in which the search for pinwheels will be contrained
title('Select Analysis Region');drawnow;
mask=roipoly;
frac=frac.*mask;

%for all pixels in the masked fracture image, find locations in which there are 3 or more
%contours meeting at a pixel.  These areas are points of convergence in the anglemap and
%are therefore a potential site for a pinwheel.  At these locations, define a circular loop
%around the pixel and count transitions between different binned responses around the loop.
%If there are 3 or more transisions in one direction around the loop, report that pixel as
%a putative site for a pinwheel of the appropriate chirality.  
disp('finding pinwheels');
for y=1:imsize(1)
    for x=1:imsize(2)
        if frac(y,x)>=3;
        [Y,X]=get_circle([y x],theta,rho);
        c=improfile(bin_im,X,Y);
        out_pos(y,x)=get_sub(c,0);
        out_neg(y,x)=get_sub(c,1);
        end
    end
%Display an update at the prompt as the image is analyzed.
    if y>=imsize(1)*count/10
        disp(sprintf('...%g percent',count*10));
        count=count+1;
    end
end
%Use some morphological operations to clean up the pinwheel location images and set them 
%as the final output.
out_pos=(imdilate(imerode(out_pos,strel('square',2)),strel('disk',3)));
out_neg=(imdilate(imerode(out_neg,strel('square',2)),strel('disk',3)));
end



%ADDITIONAL INTERNAL FUNCTIONS 
function [X,Y]=get_circle(center,theta,rho)
%Given a particular center and radius, report a circular contour around the center
[X,Y] = pol2cart(theta,rho);
X=X+center(1);
Y=Y+center(2);
end

function csum=get_sub(c,negflag)
%Calculate the summed value of the transistions from binned responses around the defined
%contour.  Depending on the value of negflag, report either clockwise or the counter-clockwise
%tendency of the transisions around the defined contour. 
for N=2:length(c)
    tmp(N)=c(N)-c(N-1);
end
if negflag==0
    csum=sum((tmp<0))>2;
else
    csum=sum((tmp<0))<2;
end
end

%Version: 1.0
%Corey J. Flynn
%Laboratory of Justin Crowley
%Department of Biological Sciences
%Carnegie Mellon University
%Contact: cjflynn@andrew.cmu.edu


