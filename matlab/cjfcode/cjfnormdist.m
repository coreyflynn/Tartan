function normdist=cjfnormdist(sigma,mu)
%%gernerates a normal distribution with the given parameters
a=-100:100;
normdist=zeros(length(a),1);
for i=1:length(a);
    normdist(i)=(1/sqrt(sigma^2*2*pi))*exp(-((a(i)-mu)^2)/2*sigma^2);
end