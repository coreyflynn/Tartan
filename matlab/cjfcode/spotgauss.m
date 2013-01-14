function spotgauss(input,i,j,p)
input=double(input);
point=0;
for N=1:p
point=point+1;
V(point)=j(N);
point=point+1;
V(point)=i(N);
point=point+1;
V(point)=0;
end
point=0;
for N=1:p
point=point+1;
x(point)=mean2(input(i(N)-5:i(N)+5,j(N)-5:j(N)+5));
point=point+1;
x(point)=.5;
point=point+1;
x(point)=.5;
end
assignin('base','x',x);
assignin('base','V',V);
x0=repmat([1 .5 .5],1,p);
x=fminunc(@(x)error_function(input,V,x),x0,optimset('MaxFunEvals',10000,'MaxIter',10000));
model=input*0;
[X,Y] = meshgrid(1:size(input,2),1:size(input,1));
for i=1:3:length(x)
model = model+(x(i)*exp(-.5*(((X-V(i)).^2/2*x(i+1)^2)+((Y-V(i+1)).^2/2*x(i+2)^2))));
end
figure(10);imagesc(model);

function result=error_function(input,V,x)
model=input*0;
[X,Y] = meshgrid(1:size(input,2),1:size(input,1));
for i=1:3:length(x)
model = model+(x(i)*exp(-.5*(((X-V(i)).^2/2*x(i+1)^2)+((Y-V(i+1)).^2/2*x(i+2)^2))));
end
result=sum(sum((model-input).^2));