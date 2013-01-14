% GET_FILTERED: Bandpass-filtering of image executed in fourier domain.
% [data_filtered kernel] = get_filtered(data,llp,hhp)
% works with GAUSSIAN filters
% Returns filtered image and filter kernel. llp is the lower frequency
% cutoff, hhp the high-frequency cutoff
%
% [data_filtered kernel] = get_filtered(data,llp,hhp, beta)
% works with FERMI filters
% Returns filtered image and filter kernel. beta specifies the slope of the
% fermi function. (Temperature of the electron gas :-))


function [map_dataf,filt] = get_filtered(map_data,roi_matrix,llp,hhp,beta)


    ext =round(2.^(ceil(log(max(size(map_data)))/log(2)))); %(This will be the size of the filters/arrays)
    a=size(map_data);

    bg=zeros(ext);     % put on square array of size 2^N (zero padding)
    bg(round((ext-a(1))/2+1):round((ext-a(1))/2+a(1)),round((ext-a(2))/2+1):round((ext-a(2))/2+a(2)))=map_data;
    roi_padd = zeros(ext);
    roi_padd(round((ext-a(1))/2+1):round((ext-a(1))/2+a(1)),round((ext-a(2))/2+1):round((ext-a(2))/2+a(2)))=roi_matrix;

    roi = find(roi_padd == 1);
    [xx,yy] = meshgrid(1:ext,1:ext);   % koordinate system
    xx=xx-ext/2;
    yy=yy-ext/2;

    if nargin > 4 %% --> implies Fermi Filtering
        disp('Doing Fermi filtering!');

        filt = zeros(size(bg));
        if llp ~= 0
            lp=ext/llp;
            filt=1./(1+exp((sqrt(xx.^2+yy.^2)-lp)./(beta)));
            
            if hhp ~= 0     %%% Fermi Bandpass
                
                hp=ext/hhp;
                filt=filt-1./(1+exp((sqrt(xx.^2+yy.^2)-hp)./(beta)));
                % Now do the filtering in Fourier domain
                map_dataf=real(ifft2(fft2(bg).*fftshift(filt)));
                %%% Take Borders into consideration
                overlap = real(ifft2(fft2(roi_padd).*fftshift(filt)));                
                map_dataf(roi) = map_dataf(roi)./overlap(roi);
                
            else    %% Pure Fermi Lowpass
                
                map_dataf=real(ifft2(fft2(bg).*fftshift(filt)));
                %%% Take Borders into consideration
                overlap = real(ifft2(fft2(roi_padd).*fftshift(filt)));                
                map_dataf(roi) = map_dataf(roi)./overlap(roi);
                
            end
        else
            
            if hhp ~= 0  %% Pure Fermi Highpass
                
                hp=ext/hhp;
                filt=1./(1+exp((sqrt(xx.^2+yy.^2)-hp)./(beta)));
                map_dataf=real(ifft2(fft2(bg).*fftshift(filt)));
                %%% Take Borders into consideration
                overlap = abs(ifft2(fft2(roi_padd).*fftshift(filt)));                
                map_dataf(roi) = bg(roi) -  map_dataf(roi)./overlap(roi);
                
            else
                filt = filt + 1;% Everything equals to one --> no damping
                disp('You have set llp and hpp to zero! No filtering is applied')
            end
        end
        
    else %% --> implies Gaussian Filtering
        
  
        % Generate Gauss bandpass filter
        filt = zeros(size(bg));

        if llp ~= 0
            lp=ext/llp;
            filt=exp(-(xx.^2+yy.^2)/2/lp^2);
            
            if hhp ~= 0 %%% Gaussian Bandpass
                
              disp('Doing Gaussian Bandpass filtering!');
              hp=ext/hhp;
                filt=filt-exp(-(xx.^2+yy.^2)/2/hp^2);        
                map_dataf=real(ifft2(fft2(bg).*fftshift(filt)));
                %%% Take Borders into consideration
                overlap = real(ifft2(fft2(roi_padd).*fftshift(filt)));                
                map_dataf(roi) = map_dataf(roi)./overlap(roi);
                
            else %% Pure Gaussian LowPass        
                
                disp('Doing Gaussian Lowpass filtering!');
                gaussian = generate_gaussian(llp);
                ab = size(gaussian);
                gauss_padd = zeros(size(bg));
                gauss_padd((ext-ab(1))/2+1:(ext-ab(1))/2+ab(1),(ext-ab(2))/2+1:(ext-ab(2))/2+ab(2)) = gaussian;

                map_dataf= real(ifft2(fft2(fftshift(gauss_padd)).*fft2(bg)));

                %%% Take Borders into consideration
                overlap = real(ifft2(fft2(roi_padd).*fft2(fftshift(gauss_padd))));                
                
                map_dataf(roi) = map_dataf(roi)./overlap(roi);
                
            end
            
        else
            
            if hhp ~= 0 %% Pure Gaussian HighPass
 %               hp=ext/hhp;
     %           filt=exp(-(xx.^2+yy.^2)/2/hhp^2);

                disp('Doing Gaussian Highpass filtering!');
                gaussian = generate_gaussian(hhp);
                ab = size(gaussian);
                gauss_padd = zeros(size(bg));
                gauss_padd(round((ext-ab(1))/2+1):round((ext-ab(1))/2+ab(1)),round((ext-ab(2))/2+1):round((ext-ab(2))/2+ab(2))) = gaussian;

                map_dataf= real(ifft2(fft2(fftshift(gauss_padd)).*fft2(bg)));

                %%% Take Borders into consideration
                overlap = real(ifft2(fft2(roi_padd).*fft2(fftshift(gauss_padd))));                
                
                map_dataf(roi) = bg(roi) - map_dataf(roi)./overlap(roi);
                
            else  %% No filtering at all
                
                filt = filt + 1;% Everything equals to one --> no damping
                disp('You have set llp and hpp to zero! No filtering is applied')
                map_dataf = bg;
            end
        end

    end

    map_dataf=map_dataf(round((ext-a(1))/2+1):round((ext-a(1))/2+a(1)),round((ext-a(2))/2+1):round((ext-a(2))/2+a(2)));
    filt=filt(round((ext-a(1))/2+1):round((ext-a(1))/2+a(1)),round((ext-a(2))/2+1):round((ext-a(2))/2+a(2)));

end




function gaussian = generate_gaussian(sigma_pixel)

    N = 6*sigma_pixel;
    if mod(N,2) == 0
        N = N + 1;
    end
    cent_x = ceil(N/2);
    x = (1:1:N) - cent_x;
    [X Y] = meshgrid(x,x);

    gaussian = exp(-1/2/sigma_pixel/sigma_pixel*(X.*X + Y.*Y)); % Gives an isotropic gaussian
end
