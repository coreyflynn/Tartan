function out=retina_box_analysis(im)
x=0;
y=0;
for i=1:10:751
    x=x+1;
    for j=1:10:751
        y=y+1;
        out(x,y)=mean2(im(i:i+49,j:j+49));
    end;
    y=0;
end
figure(1);imagesc(im);drawnow;
figure(2);imagesc(out);drawnow;
outsize=size(out);
av=zeros(1,outsize(2));
av2=zeros(1,outsize(2));
av2count=0;
figure(3);
for N=1:outsize(2);
    if N >round(outsize(1)/3) & N<round(outsize(1)/3*2)
        av2=av2+out(N,:);
        av2count=av2count+1;
    end
    av=av+out(N,:);
    plot(out(N,:));drawnow;
    hold on
end
plot(av2/av2count,'g','LineWidth',3);
plot(av/outsize(1),'r','LineWidth',3);
hold off   