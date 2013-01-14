function a=uiDVI_read
[file,dir]=uigetfile;
fid=fopen(sprintf('%s%s',dir,file),'r');
fseek(fid,1024,'bof');
a=fread(fid,[1024 1280],'uint16','ieee-be');
a=a';
fclose(fid);
