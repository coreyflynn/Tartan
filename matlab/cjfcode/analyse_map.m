%FUNCTION analyse_OD_map(filename, measure,llp,hhp, smallest_w, largest_w, step_w, do_preprocessing, do_thresholding,filter_width_bandedness)
%
%PARAMETERS:    measure ... how many pixels per millimeter
%               llp     ... lowpass cutoff frequency in millimeters
%               hhp     ... highpass cutoff frequency in millimeters
%               
%               smallest_w ...  smallest wavelength tested in millimeters
%               largest_w  ...  largest wavelength tested in millimeters
%               step_w     ...  step of wavelength test
%               filter_width_bandedness ... gaussian width of filter for
%               averaging local bandedness
%
%FLAGS          do_preprocessing ... either 1 or 0
%               do_thresholding  ... either 1 or 0
%
% Recommended settings for ferrets: llp = 0
%                                   hhp = 2.5mm
%                                   smallest_w = 0.3mm 
%                                   largest_w = 2.0mm
%                                   step_w = 0.1mm
%                                   do_preprocessing = 1
%                                   do_thresholding = 1
%                                   filter_width_bandedness = 0;

function analyse_map(filename, measure,llp,hhp, smallest_w, largest_w, step_w, do_preprocessing, do_thresholding,filter_width_bandedness)
    close all;

    tic
    %%%% First Step -- Read the Image --
    data = cpp_read2(filename);
    filename = filename(1:length(filename)-4);
    %%% Compute parameters in pixel space --> check if shrinkage needed
    smallest_w = smallest_w * 1000; %--> to micrometers
    largest_w = largest_w * 1000; %--> to micrometers
    step_w = step_w * 1000; %--> to micrometers
    absolute_scale = 1000/measure; %% how many micrometers per pixel
    
    max_ext = largest_w *10/absolute_scale;
    
    %%% find correct shrinkage value
    shrinkage = 2;
    
    while max_ext/shrinkage > 512 %%%-->higher numbers than 1024 here will cause memory overflow
        shrinkage = shrinkage + 1;
    end
   
    %%%% Shrink image (faster processing and avoid memory overflow!)
    data = shrink(data,shrinkage);
    absolute_scale = absolute_scale*shrinkage;

    figure(1)
    imagesc(data)
    set(gca, 'YDir', 'normal');
    colormap(gray);
    colorbar;
    axis equal;
    %%% Get the region of interest
    roi_matrix = zeros(size(data));
    roi_matrix(data>-1) = 1;


    if do_preprocessing == 1;
        %% now eliminate the mean, set variance to one
         data(roi_matrix == 1)  = data(roi_matrix == 1) - mean(data(roi_matrix == 1));
         data(roi_matrix == 1) = data(roi_matrix == 1)/var(data(roi_matrix == 1));
         data(roi_matrix == 0) = 0;


        %% Now filter the image
        %   First apply gaussian highpass to eliminate large scale gradients
        %   As in Kaschube et al.,  J. Neurosci. 22(16) : 7206-7217

        %   map is highpass-filtered such that the component with wavelength x mm is damped
        %   by a factor of 0.2; -> sigma = 0.43mm -> 430/absolute_scale pixels

        filter_edge = hhp; %%1.5mm

        filter_strength = 0.2;
        k_edge=2*pi/filter_edge;
        sigma_k = k_edge/sqrt(-2*log(filter_strength));% sigma of kernel in k-space
        sigma_x = 1/sigma_k*measure/shrinkage; %sigma in x-space given in pixel system, measure is pixel/mm; shrink is 2 


        imagesc(data);
        axis equal;
        set(gca, 'YDir', 'normal');
        colormap(gray);
        colorbar;
        %%%% High Pass Filtering, eliminate the mean and set variance to 1

         data_f= get_filtered(data,roi_matrix, llp,sigma_x);
         data_f(roi_matrix == 0) = 0;
         data = data_f;
    else
        roi_matrix = zeros(size(data));
        roi_matrix(data>-1) = 1;

    end
    %%%% Set variance to one, mean to zero
    data(roi_matrix == 1)  = data(roi_matrix == 1) - mean(data(roi_matrix == 1));
    data(roi_matrix == 1) = data(roi_matrix == 1)./var(data(roi_matrix == 1));
    data(roi_matrix == 0) = 0;

%     %map is now lowpass-filtered if desired
%     
%     data_f= get_filtered(data,roi_matrix, llp,0); 
%     data_f(roi_matrix == 0) = 0;
%     data = data_f;
%     data(roi_matrix == 1)  = data(roi_matrix == 1) - mean(data(roi_matrix == 1));
%     data(roi_matrix == 1) = data(roi_matrix == 1)./var(data(roi_matrix == 1));
%     data(roi_matrix == 0) = 0;

    figure(4)
    imagesc(data);
    set(gca, 'YDir', 'normal');
    colormap(gray);
    colorbar;
    axis equal;
    axis off;
    drawnow;

    if do_thresholding == 1
    
        %%%% Sophisticately thresholding the image
        th = 50;
        q = data(roi_matrix == 1);
        q = sort(q);
        n = length(q);
        avg_min=mean(q(1 : round(n / 10) + 1));
        avg_max=mean(q(n - round(n / 10) : n));
        th_hold=th/100.0*(avg_max-avg_min)+avg_min;
        up=(data > th_hold);

        data(:,:) = -1;
        data(up) = 1;
        data(roi_matrix == 0) = 0;
    end
    
    figure(4)
    imagesc(data);
    set(gca, 'YDir', 'normal');
    colormap(gray);
    colorbar;
    axis equal;
    axis off;
    drawnow;


    %%% Save the preprocessed map
    cpp_write2([filename '_prepro.mpp'], data);

    
    %%% First estimating the wavelength
    disp('Now starting to estimate the wavelength ...');

    [average_w local_w] = wavelength_estimator_data(data, roi_matrix,smallest_w,largest_w,step_w,absolute_scale);
    disp(['Average wavelength measured is ' num2str(average_w)]);
    cpp_write2([filename '_local_w.mpp'],local_w);
    
    
    figure(5)
    subplot(1,2,1)
    imagesc(local_w);
    colormap(jet);
    set(gca, 'YDir', 'normal');
    colorbar;
    axis equal;
    axis off;

    disp('Now starting to estimate the bandedness ...');
    
    [average_bandedness bandedness] = bandedness_estimator_data(data,local_w,absolute_scale, filter_width_bandedness);
    cpp_write2([filename '_bandedness.mpp'],bandedness);
    
    
    figure(5)
    subplot(1,2,2)
    imagesc(abs(bandedness));
    colormap(jet);
    set(gca, 'YDir', 'normal');
    colorbar;
    axis equal;
    axis off;
    toc

end

