%cjf_band_filter_2D(im,sampling,band)
%
%VARIABLE DEFINITIONS
%im - input image to be filtered
%
%sampling - spatial sampling rate (pixels/mm)
%
%band- 1x2 vector specifying the low and high ends of the band pass in
%cycles/mm

function imf=cjf_band_filter_2D(im,sampling,band)
%Take the 2D fourier transform of the image
FFtim=fft2(im);

%store the DC component of the transform
DC=FFtim(1,1);

%rearrange the quadrants to place the DC component in the middle of the
%spectum
FFtim=fftshift(FFtim);

%construct a bandpass filter
nyqfreq=sampling/2; %nyquist frequency given the sampling rate
filt=freqz2(ftrans2(fir1(50, band/nyqfreq)), size(FFtim));

%Apply the filter
FFtimf=filt.*FFtim;

%restore the original quadrant positions in the filtered transform and
%restore the DC component
FFtimf=ifftshift(FFtimf);
FFtimf(1,1)=DC;

%take the inverse transform
imf=real(ifft2(FFtimf));
%subplot(1,2,1);imagesc(imf);title(sprintf('Filtered From %.2fmm To %.2fmm',band(1),band(2)));
%subplot(1,2,2);imagesc(im);title('Original Image');drawnow;




