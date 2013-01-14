function Z=gauss2(height,sigma)
[X,Y]=meshgrid(-5:5,-5:5);
sigmax=sigma;
sigmay=sigma;
Z=height*exp(-((X.^2/2*sigmax^2)+(Y.^2/2*sigmay^2)));
