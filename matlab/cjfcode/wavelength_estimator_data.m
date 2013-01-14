% USAGE : wavelength_estimator(map_data, roi_matrix,small_scale, large_scale, scale_step, absolute_scale)
% This function estimates the local wavelength of an OD map
% map_data should be preprocessed --> use filters (Gaussian, or Fermi)
% roi_matrix is one in the roi and zero otherwhere!!!
%
% smallest_w : smallest wavelength possible (in micrometers)
% largest_w : largest wavelength possible (in micrometers)
% w_step :  steps (in micrometers)
% absolute scale : %% micrometers per pixel 
% How many micrometers correspond to one pixel? -> sets absolute scale
%
% The OD_map is zero padded for the FFT, and after computing the filtering
% resized to the original size


function [average_w local_w new_roi] = wavelength_estimator_data(map_data, roi_matrix, smallest_w, largest_w, w_step,absolute_scale)

    k_base = 7;
    a=size(map_data);

    max_size_needed  = max(size(map_data));
    if max_size_needed < (8 * largest_w/absolute_scale)
        max_size_needed = (8 * largest_w/absolute_scale);
    end
    
    
    %Find next power of two --> size of the padded array
    ext =round(2.^(ceil(log(max_size_needed)/log(2))));
    
    % put map on square array of size 2^N (zero padding)
    map_data_padd=zeros(ext);     

    map_data_padd(round((ext-a(1))/2+1):round((ext-a(1))/2+a(1)),round((ext-a(2))/2+1):round((ext-a(2))/2+a(2)))=map_data;
    
        
    % Fourier Transform the image in order to convolute it later on
    map_data_padd = fft2(fftshift(map_data_padd));
    
    N = 12; % N different orientations of wavelet patches are used
    
    components = zeros(N, ext,ext); % Field for the components of the individually rotated filters
    orient_av_mod = zeros(ext,ext,length(smallest_w:w_step:largest_w));% Field for the average value for one scale    

    
    index = 0;    
    % Loop over scales (wavelengths)
      
    for wavelength = smallest_w: w_step:largest_w
        index = index+1;

        % Loop over filter orientations
        for j = 0:1:N-1

            theta = pi/N*j;
            Lambda_pixel = wavelength/absolute_scale;
            k_pixel = 2*pi/Lambda_pixel;
            l = k_base/k_pixel;
            % Generate a filter with 8 sigma width
            filter = generate_wavelet_filter(round(8*l) + mod(round(8*l),2),wavelength,k_base,1,theta,absolute_scale);
            filter_padd=zeros(ext);
            b = size(filter);
            filter_padd((ext-b(1))/2+1:(ext-b(1))/2+b(1),(ext-b(2))/2+1:(ext-b(2))/2+b(2))=filter;            
             
            %%%% Filter in Real Domain
            %filt_im = abs(conv2(map_data_padd, filter,'same'));
            
            %%%%% Filtern in Fourier Domain
            filter = fft2(fftshift(filter_padd));
            filt_im = abs(fftshift(ifft2(map_data_padd.* filter)));
                        
            components(j+1,:,:) = filt_im;
            
        end % For loop of orientations
        
        orient_av_mod(:,:, index) = 1/pi/N*sum(abs(components),1);
    end% For loop over scales

    %% Resize the field (cancel zero padding)
    orient_av_mod = orient_av_mod((ext-a(1))/2+1:(ext-a(1))/2+a(1),(ext-a(2))/2+1:(ext-a(2))/2+a(2),:);

    roi = (roi_matrix == 1);
    not_roi = (roi_matrix == 0);
    disp(['Wavelet analysis using ' num2str(N)  ' orientations finished.']);
 

    %% Should use a for-loop over the whole array, even though kinda slow, due to limited RAM
 
    k_interp = 0.005;
    X = smallest_w:w_step:largest_w;
    XI = smallest_w:w_step*k_interp:largest_w;
    Y = zeros(length(X),1);
    local_w = zeros(size(orient_av_mod,1),size(orient_av_mod,2));
    disp('Now interpolating ...');
    for i = 1:size(orient_av_mod,1)
        for j = 1:size(orient_av_mod,2)
            
            if roi_matrix(i,j) == 1 %% Do that only for the roi parts

                Y(:,1) = orient_av_mod(i,j,:);

                %% Choose spline or polynomial interpolation
                YI = interp1(X, Y, XI, 'splines' );
                %P = polyfit(X,Y',6);
                %YI = P(1)*XI.^6 + P(2)*XI.^5 + P(3)*XI.^4 + P(4)*XI.^3 + P(5)*XI.^2 + P(6)*XI.^1 + P(7);


                index = find(YI == max(YI));
                if length(index) > 1 
                    index = index(1);
                end
                local_w(i,j) = XI(index);              
            end
        end
    end
    local_w(not_roi) = 0;
    
    %%%%%%%%%%% Now check if we are too close to the boundaries of the
    %%%%%%%%%%% scales
    new_roi = roi_matrix;
    q = find(local_w < (smallest_w + w_step/50));
    if ~isempty(find(q,1))
        disp('Some regions have been deleted from the region of interest due to too small wavelength!');
        local_w(q) = 0;
        new_roi(q) = 0;
    end
    q = find(local_w > (largest_w - w_step/50));
    if ~isempty(find(q,1))
        disp('Some regions have been deleted from the region of interest due to too large wavelength!');
        local_w(q) = 0;
        new_roi(q) = 0;
    end
     average_w = mean(mean(local_w(roi)));
        
end
%End of function wavelength_estimator



%%%%%%%%%%%%%%%%%%%%%%%%%% LIST OF USED FUNCTIONS %%%%%%%%%%%%%%%%



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




