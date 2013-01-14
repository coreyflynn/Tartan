% function cpp_read2(filename)
% USAGE: cpp_read2(filename);
%
% This function reads the next generation of mpp-files, called mpp2 :-)
% One file contains several matrices, that were saved at certain times
% during the integration
% File Organisation: First integer is the position of the header
% the header is : data_type, no_matrices, size of matrices, timepoints
% matrices are in between



function data = cpp_read2(filename)
fid = fopen(filename,'r');

dataType = fread(fid,1,'int');
switch dataType
    case 1
        dt = 'double';
    case 2
        dt = 'complexD';
    case 3
        dt = 'int';
    case 4
        dt = 'long';
    case 5
        dt = 'unsigned short';
    otherwise
        error('Could not identify dataType!!')
end
sx = fread(fid,1,'int');
sy = fread(fid,1,'int');

if strcmp(dt,'complexD')  %% complexD
    disp(['... loading ' dt '  ' num2str(sx) '*' num2str(sy) ' array'])
    data = fread(fid,[2,sx*sy],'double');
    re   = reshape(data(1,:),sx,sy);
    im   = reshape(data(2,:),sx,sy);
    data = re+i*im;
end 

if strcmp(dt,'double')    %% double
    disp(['... loading ' dt '  ' num2str(sx) '*' num2str(sy) ' array'])
    data = fread(fid,[1,sx*sy],'double');
    re   = reshape(data,sx,sy);
    data = re;
end

if strcmp(dt,'int')  %% complexD
    disp(['... loading ' dt '  ' num2str(sx) '*' num2str(sy) ' array'])
    data = fread(fid,[1,sx*sy],'int');
    re   = reshape(data(1,:),sx,sy);
    data = re;
end 

if strcmp(dt,'long')    %% double
    disp(['... loading ' dt '  ' num2str(sx) '*' num2str(sy) ' array'])
    data = fread(fid,[1,sx*sy],'long');
    re   = reshape(data,sx,sy);
    data = re;
end 


if strcmp(dt,'unsigned short')    %% double
    disp(['... loading ' dt '  ' num2str(sx) '*' num2str(sy) ' array'])
    data = fread(fid,[1,sx*sy],'unsigned short');
    re   = reshape(data,sx,sy);
    data = re;
end 
fclose(fid);

