function Z=2Dgauss(height)
[X,Y]=meshgrid(-5:.1:5,-5:.1:5);
sigmax=.5;
sigmay=.2;
Z=height*exp(-((X.^2/2*sigmax^2)+(Y.^2/2*sigmay^2)));
imagesc(Z);
