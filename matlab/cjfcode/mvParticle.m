function newPos=mvParticle(Pos,Grad)
%define a local neghborhood for the particle consisting of the mean values 
%of 3x3 matrices above, below, right of, left of, and at the particle's 
%current location
Nhood=zeros(3,3);
Nhood(1,2)=mean2(Grad(Pos(1)-3:Pos(1)-1,Pos(2)-1:Pos(2)+1));
Nhood(3,2)=mean2(Grad(Pos(1)+1:Pos(1)+3,Pos(2)-1:Pos(2)+1));
Nhood(2,1)=mean2(Grad(Pos(1)-1:Pos(1)+1,Pos(2)-3:Pos(2)-1));
Nhood(2,3)=mean2(Grad(Pos(1)-1:Pos(1)+1,Pos(2)+1:Pos(2)+3));
Nhood(2,2)=mean2(Grad(Pos(1)-1:Pos(1)+1,Pos(2)-1:Pos(2)+1));

%find the maximum of the neighborhood defined above and output a new
%position at that maximum.
gradMax=max(Nhood(:));
[y,x]=find(Nhood==gradMax,1);
newPos(1)=Pos(1)+y-2;
newPos(2)=Pos(2)+x-2;