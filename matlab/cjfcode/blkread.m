function f=blkread(fname)
% Usage ... f=blkread(fname)

fid=fopen(fname,'r','l');
if (fid<3),
  error(sprintf('Could not open file %s',fname));
end;

fseek(fid,0,'eof');
tmp_iend=ftell(fid);

fseek(fid,12,'bof');
off1=fread(fid,1,'long');

fseek(fid,32,'bof');
tmp=fread(fid,10,'long');

f.nbytes=tmp(1);
f.dim=tmp(2:3);
f.ncond=tmp(4);
f.nfrpcond=tmp(5);

fseek(fid,100,'bof');
dateinfo=fread(fid,20,'char=>char');

fseek(fid,672,'bof');
condinfo=fread(fid,25,'char=>char');

fseek(fid,928,'bof');
dataperfr=fread(fid,1,'long');

disp(sprintf('  nbytes= %d, ncond= %d, nfr_percond= %d',f.nbytes,f.ncond,f.nfrpcond));
disp(sprintf('  xdim= %d, ydim= %d, offset= %d',f.dim(1),f.dim(2),off1));
disp(sprintf('  date= %s',dateinfo));
disp(sprintf('  cond= %s',condinfo));

fseek(fid,off1,'bof');
for mm=1:f.ncond,
  for nn=1:f.nfrpcond,
    f.data(:,:,mm,nn)=fread(fid,[f.dim(1) f.dim(2)],'long');
  end;
end;

%f.data=fread(fid,[1020 1020],'short');
fi_end=ftell(fid);
%[tmp_iend fi_end],
fclose(fid);

