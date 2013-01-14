function cjftest(input,omega)
%%only one dimenstional as of yet...
z=0;
zimag=zeros(length(input),1);
zreal=zeros(length(input),1);
zimagsq=zeros(length(input),1);
zrealsq=zeros(length(input),1);
zrealsqmean=0;
zimagsqmean=0;
codeltamean=0;
Prob=zeros(50);
for N=1:length(input)
    oldfrac=(N-1)/N;
    z=oldfrac*z+(exp(i*omega*N)*input(N))/N;
    zreal(N)=real(z);
    zimag(N)=imag(z);
    S(1)=mean(zreal(1:N));
    S(2)=mean(zimag(1:N));
    M(1)=std(zreal(1:N));
    M(2)=std(zimag(1:N));
    figure(3);title(N);
    cjfnormdist2(S,M);
end