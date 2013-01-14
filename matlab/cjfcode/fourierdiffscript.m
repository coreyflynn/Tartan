%used to generate normalized difference images for a stack created with
%fourieraveragescript.m.  The differeence images are saved as .mpp files
%ready for wavelength analysis.

%%Set up the basic variables needed to run the script.
savepath='/Volumes/TERABITHIA2/Data 2008/F08_103/Day2/Analysis/';
figure(1);
diff=(averagestack(:,:,1)+averagestack(:,:,19)/2)-(averagestack(:,:,10)+averagestack(:,:,28)/2);
imagesc(diff);colormap(gray);title('select an ROI to normilze over');caxis([-25 25]);
mask=roipoly;
orientationdiff=zeros(1024,1024,18);
directiondiff=zeros(1024,1024,36);
figure(2);

%%operate on the previosly generated averagestack to generate orientation
%%difference images.
for N=1:18
    pos=(averagestack(:,:,N)+averagestack(:,:,N+18)/2);
    neg=(averagestack(:,:,mod(N+9,36)+1)+averagestack(:,:,mod(N+27,36)+1)/2);
    ratio=mean(pos(find(mask==1)))/mean(neg(find(mask==1)));
    pos=pos*ratio;
    diff=pos-neg;
    diff=diff-min(min(diff(find(mask==1))));
    diff(find(mask==0))=-1;
    orientationdiff(:,:,N)=diff;
    s=[savepath 'diffs/F08_103_orientation' num2str(N)];
    cpp_write2(s,orientationdiff(:,:,N));
    subplot(3,6,N);imagesc(orientationdiff(:,:,N));colormap(gray);title(sprintf('(%d+%d)-(%d+%d)',N,N+18,N+9,N+27));
    drawnow;
end
%figure(3);
%for N=1:36
%    pos=(averagestack(:,:,N));
%    neg=(averagestack(:,:,mod(N+18,36)+1));
%    ratio=mean(pos(find(mask==1)))/mean(neg(find(mask==1)));
%    pos=pos*ratio;
%    diff=pos-neg;
%    diff=diff-min(min(diff(find(mask==1))));
%    diff(find(mask==0))=-1;
%    directiondiff(:,:,N)=diff;
%    s=[savepath 'diffs/F08_103_direction' num2str(N)];
%    cpp_write2(s,directiondiff(:,:,N));
%    subplot(6,6,N);imagesc(directiondiff(:,:,N));colormap(gray);title(sprintf('(%d-%d)',N,N+18));
%    drawnow;
%end