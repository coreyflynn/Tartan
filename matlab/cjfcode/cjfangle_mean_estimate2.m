function cjfangle_mean_estimate2(input,omega)
%%2D version of cjfangle_mean_estimate.m
imsize=size(input);
z=zeros(imsize(1),imsize(2));
magmean=zeros(imsize(1),imsize(2));
angmean=zeros(imsize(1),imsize(2));
magsqmean=zeros(imsize(1),imsize(2));
angsqmean=zeros(imsize(1),imsize(2));
figure(6);
for N=1:length(input)
    oldfrac=(N-1)/N;
    z=oldfrac*z+(exp(i*omega*N)*input(:,:,N))/N;
    mag=sqrt(abs(real(z).^2+imag(z).^2));
    magmean=oldfrac*magmean+mag/N;
    magsqmean=oldfrac*magsqmean+((mag-magmean).^2)/N;
    ang=atan2(imag(z),real(z))*180/pi;
    angmean=oldfrac*angmean+ang/N;
    angsqmean=oldfrac*angsqmean+((ang-angmean).^2)/N;
    subplot(2,2,1);imagesc(angmean);title('Angle Estimate');
    subplot(2,2,2);imagesc(angsqmean.^2);title('Angle Variance');
    subplot(2,2,3);imagesc(magmean);title(N);title('Magnitude Estimate');
    subplot(2,2,4);imagesc(magsqmean.^2);title('Magnitude Variance');
    if mod(N,36)==0
        s=['/home/cflinn/OISurrogateData/NoiseImSeries/' num2str(N) '.jpg'];
        saveas(gcf,s);
    end
    pause(.01);
end