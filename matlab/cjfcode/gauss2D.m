function Z=gauss2D(height,sigmax,sigmay)
[X,Y]=meshgrid(-5:.1:5,-5:.1:5);
Z=height*exp(-((X.^2/2*sigmax^2)+(Y.^2/2*sigmay^2)));
imagesc(Z);
