function gailshow
% impliments Sf=A(exp(B(epsilon))-1)
syms theta;
Sf=.971*(exp(46.303*(0:.01:.16))-1);
tmp=int(Sf*cos(theta)^2,-pi/2:pi/2);
tmp
for j=10:10:60
    for N=1:17
        f=@(theta,llimits) eval(tmp(N));
        tmp2(N)=feval(f,j/180*pi,1);
        plot(tmp2);drawnow;hold on;
    end
end
hold off;