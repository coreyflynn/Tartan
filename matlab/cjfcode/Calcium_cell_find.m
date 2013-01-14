function [i,j,p]=Calcium_cell_find(Input,stdthresh)
G_flat=homocorOIScjfmod(double(Input));
%play with these bandpass options to optimize results
G_flat_filt=bpass(G_flat,2,5);
MaskImage= G_flat>(mean2(G_flat)+std2(G_flat)*stdthresh) & G_flat_filt>0;
[i,j,p] = cjfblobdetector(G_flat_filt, 20, 8, 0, 0, MaskImage);
figure(1);imagesc(Input);title('spot overlay on original');truesize;hold on;scatter(j,i,'w');
figure(2);imagesc(G_flat_filt);title('spot overlay on filtered');truesize;hold on;scatter(j,i,'w');