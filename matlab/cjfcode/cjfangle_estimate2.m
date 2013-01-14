function cjfangle_estimate2(input,omega)
%%only one dimenstional as of yet...
z=0;
zrealmean=0;
zimagmean=0;
zrealsqmean=0;
zimagsqmean=0;
codeltamean=0;
Prob=zeros(50);
C=zeros(2);
for N=1:length(input)
    oldfrac=(N-1)/N;
    z=oldfrac*z+(exp(i*omega*N)*input(N))/N;
    zrealmean=oldfrac*zrealmean+(real(z))/N;
    zimagmean=oldfrac*zimagmean+(imag(z))/N;
    zrealsqmean=oldfrac*zrealsqmean+(real(z)^2)/N;
    zimagsqmean=oldfrac*zimagsqmean+(real(z)^2)/N;

    codeltamean=oldfrac*codeltamean+((real(N)-zrealmean)*(imag(N)-zimagmean))/N;
    C(1,1)=zrealsqmean-zrealmean^2;
    C(2,2)=zimagsqmean-zimagmean^2;
    C(1,2)=codeltamean;
    C(2,1)=codeltamean;
    for x=1:100
        for y=1:100
            inner=[x-50-zrealmean;y-50-zimagmean];
            Prob(x,y)=1/2*pi*sqrt(det(C))*exp(-.5*(inner')*inv(C)*inner);
        end
    end
    imagesc(real(Prob));title(N);
    pause(.001);
end