function normdist2=cjfnormdist2(sigma,mu)
%%gernerates a normal distribution with the given parameters in two 
%%dimensions and plots it.  This function builds on cjfnormdist.m
dist1=normpdf(-1:1/180:1,mu(1),sigma(1));
dist2=normpdf(-1:1/180:1,mu(2),sigma(2));
[X,Y]=meshgrid(dist1,dist2);
normdist2=X.*Y;
normdist2(1:360,180)=max(max(normdist2))/4;
normdist2(180,1:360)=max(max(normdist2))/4;
figure(3);imagesc(normdist2); colormap(gray);
