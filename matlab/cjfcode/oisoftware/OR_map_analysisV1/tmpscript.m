dorsal=zeros(6,length(slice6.density));
for N=1:6
tmp1=eval(sprintf('slice%g.cy',N));
tmp2=eval(sprintf('slice%g.cy',3));
offset=round((tmp1(100)-tmp2(100))/10);
tmplength=length(tmp1);
densitytmp=eval(sprintf('slice%g.density',N));%densitytmp=cjf_band_filter(densitytmp,1,[1/20 1/10 ],0);
try
dorsal(N,offset+1:length(densitytmp)+offset)=densitytmp;
catch M
dorsal(N,offset+1:length(densitytmp)+offset+1)=densitytmp;
end
end