function images=cjfDIGEPanel(Cy3im,Cy5im)
%% first flatten the images using alberto's algorithm
Cy3im=double(Cy3im);
Cy5im=double(Cy5im);
images.FlatCy3im=homocorOIScjfmod(Cy3im);
images.FlatCy5im=homocorOIScjfmod(Cy5im);


