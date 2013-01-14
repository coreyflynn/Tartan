function a=DVI_read(fname)
fid=fopen(fname,'r');
fseek(fid,1024,'bof');
a=fread(fid,[1024 1280],'uint16','ieee-be');
a=a';
fclose(fid);
