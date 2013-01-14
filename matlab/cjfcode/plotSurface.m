function plotSurface(V,thresh,color,aspect,alph)
p = patch(isosurface(V,thresh));
isonormals(V,p)
set(p,'FaceColor',color,'EdgeColor','none','FaceAlpha',alph);
daspect(aspect)
view(3); axis tight; axis vis3d; axis off;
camlight;
lighting gouraud;