function z=cjfangle_estimate(input,omega)
%%only one dimenstional as of yet...
z=zeros(round(length(input)/(2*pi/omega)+1),1);
tmp=zeros(round(length(input)/(length(input)/(2*pi/omega))),length(input)/(2*pi/omega));
cycle=1;
pointer=1;
for N=1:length(input)-1
    oldfrac=(pointer-1)/pointer;
    z(cycle)=oldfrac*z(cycle)+(exp(i*omega*(pointer-1))*input(N)/pointer);
    tmp(pointer,cycle)=z(cycle);
    %plot(tmp(1:pointer,cycle));title(N);grid on;
    pause(.01);
    if mod(N,(2*pi/omega))==0        
        compass(real(z(cycle)),imag(z(cycle)));
        hold on;
        cycle=cycle+1;
        pointer=0;
        drawnow;
    end
    pointer=pointer+1;
end
hold off;
if mod(pointer,(2*pi/omega))~=0
    z=z(1:cycle-1);
end
title(sprintf('analysis frequency = %d cycles/min',omega/(2*pi/360)),'FontSize',20);