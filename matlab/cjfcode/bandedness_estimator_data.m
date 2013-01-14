%USAGE:  [average_bandedness bandedness] = bandedness_estimator_data(A,local_w,absolute_scale)
%
%
% This function estimates the local bandedness of an OD map, estimate local
% wavelength first!
% absolute scale : %% micrometers per pixel 
% How many micrometers correspond to one pixel? -> sets absolute scale

function [average_bandedness bandedness] = bandedness_estimator_data(map, local_w, absolute_scale, filter_width)
%%
 
    % Get the region of interest!
    roi = ones(size(local_w));    
    roi(local_w == 0) = 0;
    average_w = mean(mean(local_w(roi == 1)));
    %%%% Setting the parameters for wavelet generation
    k_base = 2;
    aniso = 1.5;
    [n m] = size(map);
    N = 8;
    bandedness = zeros(size(map));   
    
    %%%% Determine maximal filter extension
    wavelength = max(max(local_w));
    Lambda_pixel = wavelength/absolute_scale;
    k_pixel = 2*pi/Lambda_pixel;
    ll = k_base/k_pixel;
    max_filter_ext = round(8*ll*aniso) + mod(round(8*ll*aniso),2);
    
    
    
    %%% padd array such that valid convolution range far all filters is at least as large as the
    %%% original map!!
    
    ext_x =n + max_filter_ext;
    ext_y =m + max_filter_ext;

    bg=zeros(ext_x,ext_y);     % put on square array of size 2^N (zero padding)
    bg(round((ext_x-n)/2+1):round((ext_x-n)/2+n),round((ext_y-m)/2+1):round((ext_y-m)/2+m))=map;

    
    for k = 1:n
        for l = 1:m
            vector_sum = 0;
            norm = 0;
            if roi(k,l) == 1
                for j = 0:1:N-1
                    theta = pi/N*j;
                    wavelength = local_w(k,l);
                    Lambda_pixel = wavelength/absolute_scale;
                    k_pixel = 2*pi/Lambda_pixel;
                    ll = k_base/k_pixel;

                    %%%% Generate only a small patch (small gabor filter) (width == 6 times local wavelengths)
                    filter = generate_wavelet_filter(round(8*ll*aniso) + mod(round(8*ll*aniso),2),wavelength,k_base,aniso,theta,absolute_scale);
                    
                    [filt_x filt_y] = size(filter);

                    coeff= abs(convolute_with_patch(bg, filter, k + 1 + (max_filter_ext - filt_x)/2,l + 1 + + (max_filter_ext - filt_y)/2));
                    vector_sum = vector_sum + coeff * coeff * exp(2*i*theta);
                    norm = norm + coeff * coeff;
                end
                bandedness(k,l) = vector_sum/norm;
            end
        end
    end
    
    %% Now take the local average of the bandedness -> need again to
    %% convolute but now only with one gaussian patch
    if filter_width > 0
      bandedness = fft2(fftshift(bandedness));
      filter2 = generate_gaussian(map,filter_width,average_w,absolute_scale);
      norm_filter2 = sum(sum(filter2));
      filter2 = fft2(fftshift(filter2));
      % Convolute
      bandedness = filter2.* bandedness;
      bandedness = real(fftshift(ifft2(bandedness)))./ norm_filter2;
      overlap = real(ifft2((fft2(roi).*filter2)))./norm_filter2;
      bandedness = bandedness./overlap;
    end

    bandedness(roi == 0) = 0;
    average_bandedness = mean(mean(bandedness(roi == 1)));
    
   
    


end
%%% End of function bandedness_estimator



%%%%%%%  List of used functions


function gaussian = generate_gaussian(A,sigma,average_wavelength,absolute_scale)
    [N M] = size(A);
    L = absolute_scale * N;
    sigma = sigma*average_wavelength;

    if mod(N,2) == 0
        cent_x = floor(N/2+1);% zero frequency component!!! -> "center" of the matrix
    else
        cent_x = ceil(N/2+1);
    end
    if mod(M,2) == 0
        cent_y = floor(M/2+1);
    else
        cent_y = ceil(M/2+1);
    end

    x = (1:1:N) - cent_x;
    y = (1:1:M) - cent_y;

    x = x./max(max(x))/2 * L;
    y = y./max(max(y))/2 * L;

    [X Y] = meshgrid(x,y);
    
    X = X';
    Y = Y';

    gaussian = 1/2/pi/sigma*exp(-1/2/sigma/sigma*(X.*X + Y.*Y)); % Gives an isotropic gaussian
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%function sum = convolute_with_patch(im, m, yr,yc)
%USAGE: This function convolutes an array with periodic boundary conditions
%and returns the value at a specific point of the array
% INPUT:
% im ...    array to convolute
% m  ...     mask (filter), should be of size smaller than the array
% yr ...     row-position of the value
% yc ...     column-position of the value
% function is called by bandedness_estimator.m


function sum = convolute_with_patch(im, m, yr,yc)
    [nxr, nxc] = size(im);    % nxr: number of im rows, etc.
    [nmr, nmc] = size(m);

    if max([nxr, nxc]) < max([nmr, nmc])
        error('Filter mask is larger than image! This doesnt make much sense! ')
    end
    
    sum = 0;
    for mr = 1:nmr    % loop over mask elements
        for mc = 1:nmc
            sum = sum + im(yr-mr+nmr, yc-mc+nmc) * m(mr, mc);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%% Function GENERATE_WAVELET_FILTER %%%%%%%%%%%%%%
% function wavelet = generate_wavelet_filter(N,wavelength,k,aniso,theta,absolute_scale)
%   USAGE:
%   N           ... size of the filter (is a square matrix)
%   wavelength  ... wavenumber in the filter (should be integer) attention to periodicity!!!!!!!!!!
%   sigma       ... width of the gaussian in units of Lambda
%   aniso       ... anisotropy between x and y direction
%   theta       ... angle of the modulating wave
%   RETURN VALUE: a complex wavelet function
function wavelet = generate_wavelet_filter(N,wavelength,k,aniso,theta,absolute_scale)

    Lambda_pixel = wavelength/absolute_scale;
    k_pixel = 2*pi/Lambda_pixel;
    [X Y] = meshgrid(1:N,1:N);
    X=X-ceil(N/2);
    Y=Y-ceil(N/2);

    wave = cos(cos(theta)*X*k_pixel + sin(theta)*Y*k_pixel) + i*sin(cos(theta)*X*k_pixel + sin(theta)*Y*k_pixel);

    l = k/k_pixel;

    gaussian = 1/l*exp(-1/2/l/l*(X.*X + 1/aniso/aniso*Y.*Y)); % Gives an anisotropic gaussian

    %% Now multiply this pointwise with the gaussian, around the center of the matrix
    wavelet = gaussian.*wave;    
    wavelet = wavelet - mean(mean(wavelet));
end



