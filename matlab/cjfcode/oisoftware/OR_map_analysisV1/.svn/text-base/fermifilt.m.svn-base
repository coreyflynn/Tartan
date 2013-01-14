function filtim=fermifilt(im,mm_bound,pix_res)
%This is a funciton in which a spatial fermi filter is applied to an image
%in fourier space.  The ouput is the spatially low pass filtered image. 
%
%USAGE
%filtim=fermifilt(im,pix_bound)
%
%VARIABLE DEFINITIONS
%im - Input image to be filtered
%mm_bound - The wavelength in µm at which the fermi filter is defined to give a 
%			50% response.  This is effectively the border of the low pass
%			filter to be applied ot the image.
%pix_res - The pixel resolution for the image. 
%filtim - The filtered image to be output.

%From the image size, pixel resolution, and desired 50% filter response, calculate
%the appropriate pixel cutoff for the filter to be applied to the 2D fft. 
imsize=size(im);
ap_size=pix_res*imsize(2);
pix_bound=ap_size/mm_bound;

%Create a matrix that is the same size as the input image and will serve as a map 
%of the distance from the center of the 2D fft image.
X=repmat(1:imsize(2),imsize(1),1);
X=X-imsize(2)/2;
Y=repmat(1:imsize(1),imsize(2),1);
Y=Y-imsize(1)/2;
Y=Y';
dist=sqrt(X.^2+Y.^2);

%Define the fermi filter to be used
fermi2=1./(1+exp(-((pix_bound-abs(dist))./(.05*pix_bound))));

%calculate the 2D fft of the input image and apply the fermi filter to that image.
%next, take the inverse transform in order to get the filtered image back. 
ffted=fftshift(fft2(im,imsize(1),imsize(2)));
filtim=abs(ifft2(ffted.*fermi2));

%Version: 1.0
%Corey J. Flynn
%Laboratory of Justin Crowley
%Department of Biological Sciences
%Carnegie Mellon University
%Contact: cjflynn@andrew.cmu.edu


