function optstl(stack)
%find all the objects in the 3d matrix
L=bwlabeln(stack);
for M=1:max(max(max(L)))
    X=[];
    Y=[];
    Z=[];
    for N=1:size(L,3)
        mask=L(:,:,N)==M;
        perim=bwperim(mask);
        if max(mask(:))>0
        [x,y]=find(perim==1);
        z=ones(length(x),1)*N;
        X=vertcat(X,x);
        Y=vertcat(Y,y);
        Z=vertcat(Z,z);
        end
    end
    k=convhulln([X Y Z]);
    isosurface([X(k) Y(k) Z(k)],.99);drawnow;
    hold on;
end
        