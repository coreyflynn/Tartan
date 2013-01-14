a=1:3601;
omega=2*pi/180;
signal=sin(omega*a);
cnoise=colornoise(3600,10);
data=signal+cnoise;
cjfangle_estimate(data,omega);