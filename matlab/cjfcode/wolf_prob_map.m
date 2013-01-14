a=0:3600;
omega=2*pi/180;
signal=cos(omega*a);
z=zeros(20,100);
figure;
for iter=1:100
    cnoise=colornoise(3600,10);
    input=signal+cnoise;
    cycle=1;
    pointer=1;
    for N=1:length(input)-1
        oldfrac=(pointer-1)/pointer;
        z(cycle,iter)=oldfrac*z(cycle,iter)+(exp(i*omega*(pointer-1))*input(N)/pointer);
        if mod(N,180)==0
            scatter(real(z(cycle,iter)),imag(z(cycle,iter)));
            hold on
            cycle=cycle+1;
            pointer=0;
            pause(.001);
        end
        pointer=pointer+1;
    end
    hold on
    iter
end