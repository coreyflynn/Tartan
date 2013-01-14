function [X,Y,Z,breaks,path,file]=tiff_multi_reconstruct(xy_res,z_res,plot_flag,tissue_flag,rthresh,gthresh)

[file,path]=uigetfile({'*.tif';'*.tiff'},'Select red channel Stack','~/Desktop');
disp('reading images');
tiffstack=tiffread2(sprintf('%s%s',path,file));
for N=1:length(tiffstack)
    tmpstack(:,:,N)=imrotate(tiffstack(N).data,-90);
end
tmpstack=double(tmpstack);
if strcmp(tissue_flag,'ctx')==1
    imagesc(tmpstack(:,:,1));colormap(gray);
    title('Mask out pial surface');drawnow;
    mask=roipoly;
elseif strcmp(tissue_flag,'lgn')==1
    mask=tmpstack(:,:,1)*0;
end
for N=1:length(tiffstack)
    tmpstack(:,:,N)=tmpstack(:,:,N).*~mask;
end
ctxrthresh=max(max(max(tmpstack)))*rthresh;
lgnrthresh=max(max(max(tmpstack)))*rthresh;
if strcmp(tissue_flag,'ctx')==1
    [X.r,Y.r,Z.r,breaks.r]=tiff_reconstruct(xy_res,z_res,tmpstack,ctxrthresh);
elseif strcmp(tissue_flag,'lgn')==1
    [X.r,Y.r,Z.r,breaks.r]=tiff_reconstruct(xy_res,z_res,tmpstack,lgnrthresh);
end

clear tmpstack;
[file,path]=uigetfile({'*.tif';'*.tiff'},'Select green channel Stack',path);
disp('reading images');
tiffstack=tiffread2(sprintf('%s%s',path,file));
for N=1:length(tiffstack)
    tmpstack(:,:,N)=imrotate(tiffstack(N).data,-90);
end
tmpstack=double(tmpstack);

for N=1:length(tiffstack)
    tmpstack(:,:,N)=tmpstack(:,:,N).*~mask;
end
ctxgthresh=max(max(max(tmpstack)))*gthresh;
lgngthresh=max(max(max(tmpstack)))*gthresh;
if strcmp(tissue_flag,'ctx')==1
    [X.g,Y.g,Z.g,breaks.g]=tiff_reconstruct(xy_res,z_res,tmpstack,ctxgthresh);
elseif strcmp(tissue_flag,'lgn')==1
    [X.g,Y.g,Z.g,breaks.g]=tiff_reconstruct(xy_res,z_res,tmpstack,lgngthresh);
end

if plot_flag==1
    z_step=z_res/xy_res;
    m_size=z_step/3;

    tmp(:,1)=X.g;
    tmp(:,2)=Y.g;
    tmp(:,3)=Z.g;
    tmp2(:,1)=X.r;
    tmp2(:,2)=Y.r;
    tmp2(:,3)=Z.r;

    overlap=intersect(tmp,tmp2,'rows');

    disp('generating 3D plot...');
    fig=figure;
    plot3(X.r,Y.r,Z.r,'o','MarkerEdgeColor','r','MarkerFaceColor','r'...
        ,'MarkerSize',m_size);hold on;
    plot3(X.g,Y.g,Z.g,'o','MarkerEdgeColor','g','MarkerFaceColor','g'...
        ,'MarkerSize',m_size);hold on;
    plot3(overlap(:,1),overlap(:,2),overlap(:,3),'o'...
        ,'MarkerEdgeColor','y','MarkerFaceColor','y'...
        ,'MarkerSize',m_size);hold off;
    set(fig,'DoubleBuffer','on','Color','k');
    axis equal;
    axis vis3d;
    axis off;
    drawnow;
end

