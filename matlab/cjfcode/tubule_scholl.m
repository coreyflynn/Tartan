function tubule_scholl(stack,radius,thickness)
%these are taken as constants
xy_res=.13; %um/pixel
z_res=1; %um/pixel
radius=radius/xy_res;
thickness=thickness/xy_res;
imsize=size(stack);
X=repmat(1:imsize(2),imsize(1),1);
Y=repmat((1:imsize(1))',1,imsize(2));
imagesc(Y);
center.x=309.2;
center.y=287.1;
center.z=6;
for N=1:imsize(3)
    tmp=stack(:,:,N);
    tmp=tmp/max(tmp(:));
    mask=get_mask(X,Y,center,N,radius,z_res,thickness,imsize);
    bw=im2bw(tmp,.08);
    labeled=bwlabel(bw.*mask);
    imagesc(tmp.*mask);drawnow;pause(.1);
    disp(sprintf('Slice#%g, %g tubules',N,max(labeled(:))));
end


function mask=get_mask(X,Y,center,slice,radius,z_res,thickness,imsize)
z_component=abs(center.z-slice)*z_res;
new_radius=sqrt(radius^2-z_component^2);
new_thickness=sqrt(thickness^2-z_component^2);
mask=zeros(imsize(1),imsize(2));
mask(sqrt((X-center.x).^2+(Y-center.y).^2)<new_radius)=1;
mask(sqrt((X-center.x).^2+(Y-center.y).^2)<new_radius-new_thickness)=0;
assignin('base','mask2',mask);
