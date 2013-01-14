function FiltIm=DIGEFermi(RawIm)
% Inputs a raw DIGE gel image and filters all of the panels of that image
% using a 2D fermi filter to reduce the effect of background in the image.
% The image is assumed to have been generated as a 4x5 grid of 256x256 images
% and is processed with a fermi filter with a 128 pixel cutoff
BG=fermifilt(RawIm,128,1);
FiltIm=RawIm-BG;
FiltIm=FiltIm-min(FiltIm(:));
