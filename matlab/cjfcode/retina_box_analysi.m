function out=retina_box_analysi(im,start,finish)
x=0;
y=0;
filtim=fermifilt(im,100,1);
%filtim=im;
for i=1:10:size(filtim,1)-49
    x=x+1;
    for j=1:10:size(filtim,2)-49
        y=y+1;
        out(x,y)=mean2(filtim(i:i+49,j:j+49));
    end;
    y=0;
end
figure(1);imagesc(out);
outsize=size(out);
x=1:size(out,1);
y=1:size(out,2);
[X,Y]=meshgrid(x,y);
figure(2);
for N=start:finish
    figure(2);plot3(X(N,:),Y(N,:),out(N,:));
    hold on;
end
for N=start:finish
	figure(3);plot(out(N,:));
	hold on;
end
line(1:outsize(1),mean(out(start:finish,:)),'LineWidth',10,'Color','k');
line(1:outsize(1),min(out(start:finish,:)),'LineWidth',10,'Color','b');
line(1:outsize(1),max(out(start:finish,:)),'LineWidth',10,'Color','b');
figure(4); surf(X,Y,out,out);
    