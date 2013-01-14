function mass=western_mass_estimate
%input a blot image
[file1,path1]=uigetfile({'*.bmp';'*.jpg';'*.tif'},'Select Blot Image'...
    ,'~/Desktop');
blotim = imread(sprintf('%s/%s',path1,file1));
bands=[10 17 26 34 43 55 72 95 130 170];
for N=1:10
    figure(1);imagesc(blotim);truesize;colormap(gray);drawnow;
    title(sprintf('click on the %gkDa ladder band',bands(N)));
    [x(N),y(N)]=ginput(1);
end
p=polyfit(y,bands,4);
figure(2);plot(polyval(p,y),y);hold on;
mass=[];
qans='Yes';
count=1;
while strcmp(qans,'Yes')==1
    figure(1);imagesc(blotim);colormap(gray);drawnow;
    title('click on the band of interest');
    [x2,y2]=ginput(1);
    mass=horzcat(mass,polyval(p,y2));
    figure(2);scatter(mass(count),y2,'r');
    count=count+1;
    qans=questdlg('Measure Another Band?');
end
figure(2);hold off;