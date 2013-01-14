function BistackToVol(stack,xy_res,z_res,thresh,flag,alpha_val,c_flag)
bistack=stack*0;
count=0;
for N=1:size(stack,3)
count=count+1;
if strcmp(flag,'dark')==1
    bistack(:,:,count)=stack(:,:,N)>thresh;
    figure(1);
    axis off;
    set(gcf,'Color','k');
elseif strcmp(flag,'bright')==1
    bistack(:,:,count)=stack(:,:,N)<thresh;
    figure(1);
    axis off;
    set(gcf,'Color','w');
end
bistack(:,:,count)=imopen(bistack(:,:,count),strel('disk',1));
end
%camorbit(0,90);
view(0,50);
z_step=z_res/xy_res;
stack=stack./max(max(max(stack)));
hold on;
TRI=[4     2     1
     3     4     1
     7     3     1
     5     7     1
     7     4     3
     4     7     8
     2     6     1
     6     5     1
     4     6     2
     6     4     8
     6     7     5
     7     6     8];
Xvert=[-.5,-.5,.5,.5,-.5,-.5,+.5,+.5];
Yvert=[-.5,.5,-.5,.5,-.5,.5,-.5,+.5];
Zvert=[0,0,0,0,z_step,z_step,z_step,z_step];
for N=1:size(bistack,3)
    if max(max(bistack(:,:,N)))==1;
        [X,Y]=find(bistack(:,:,N)==1);
        for M=1:length(X)
            Xtmp=X(M)+Xvert;
            Ytmp=Y(M)+Yvert;
            Ztmp=N*z_step+Zvert;
            pointC=stack(X(M),Y(M),N);            
            C=getcolor(c_flag,pointC);
            trisurf(TRI,Xtmp,Ytmp,Ztmp,'FaceColor',C,'FaceAlpha',alpha_val...
                ,'EdgeColor','none');
            %axis normal
        end
        drawnow;
    end
end
hold off;
%axis equal;
axis vis3d;

function C=getcolor(c_flag,pointC)
switch c_flag
    case 'g'
        C=[0 pointC 0];
    case 'r'
        C=[pointC 0 0];
    case 'g'
        C=[0 pointC 0];
    case 'b'
        C=[0 0 pointC];
    case 'y'
        C=[pointC pointC 0];
    case 'k'
        C=[pointC pointC pointC];
end