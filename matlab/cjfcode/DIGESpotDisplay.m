function DIGESpotDisplay(images,summary,spotnum)
[ylist,xlist]=find(images.SpotDomains==summary.SigSpots(spotnum));
Cy3tmp=imcrop(images.FlatCy3,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
Cy5tmp=imcrop(images.FlatCy5,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
figure(2);subplot(1,3,1); surf(Cy3tmp,'edgecolor','none');title('Cy3 spot');shading interp;
subplot(1,3,2); surf(Cy5tmp*summary.RatioMean,'edgecolor','none');title('Cy5 spot');shading interp;
subplot(1,3,3); surf(Cy3tmp-Cy5tmp*summary.RatioMean,'edgecolor','none');title('Cy3-Cy5 Difference');shading interp;
v=axis;v(5)=-10;v(6)=10;axis(v);
figure(3);subplot(1,2,1);imagesc(images.FlatCy3);
rectangle('EdgeColor','r','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)])
figure(3);subplot(1,2,2);imagesc(images.FlatCy5);
rectangle('EdgeColor','r','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)])