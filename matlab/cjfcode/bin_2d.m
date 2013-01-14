function tmpsmall=bin_2d(tmp)
tmpsmall=zeros(512);
in=0;
jn=0;
for i=1:2:1023
    in=in+1;
    for j=1:2:1023
        jn=jn+1;
        tmpsmall(in,jn)=mean2(tmp(i:i+1,j:j+1));
    end
    jn=0;
end
