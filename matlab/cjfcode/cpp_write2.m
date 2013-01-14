function cpp_write2(filename,data)
% interface to exchange matrices with c++ program
% a=randn(3)+i*randn(3);cpp_write('/home/mick/test_1',a)

% check datatype - complex or real double?

%%
[sx,sy]=size(data);

if (imag(data)==zeros(size(data)) & strcmp(class(data),'double'))
    dataType=1;
    
elseif strcmp(class(data),'double')
    dataType=2;

elseif strcmp(class(data),'long')
    dataType=4;
    
elseif strcmp(class(data),'int32')
    dataType=4;

elseif strcmp(class(data),'int16')
    dataType= 3; 

elseif strcmp(class(data),'int16')
    dataType= 3; 

else
    disp('Could not identify datatype !');   
end

fid = fopen(filename,'w');
fwrite(fid,dataType,'int');      %% Write data type to file
fwrite(fid,sx,'int');        %% Write length of array to file
fwrite(fid,sy,'int');


switch dataType
    case 1
        disp(['... saving double ' num2str(sx) '*' num2str(sy) ' array to file ' filename])
        data=reshape(data,1,sx*sy);

        fwrite(fid,data,'double');
    case 2
        disp(['... saving complexD ' num2str(sx) '*' num2str(sy) ' array to file ' filename])
        data=reshape(data,1,sx*sy);
        dat(1,:)=real(data);
        dat(2,:)=imag(data);
        fwrite(fid,dat,'double');
    case 3
        disp(['... saving integer ' num2str(sx) '*' num2str(sy) ' array to file ' filename])
        data=reshape(data,1,sx*sy);

        fwrite(fid,data,'int');
    case 4
        disp(['... saving long ' num2str(sx) '*' num2str(sy) ' array to file ' filename])
        data=reshape(data,1,sx*sy);

        fwrite(fid,data,'long');
    case 5
        disp(['... saving unsigned short ' num2str(sx) '*' num2str(sy) ' array to file ' filename])
        data=reshape(data,1,sx*sy);

        fwrite(fid,data,'unsigned short');
    otherwise
        error('Could not identify dataType!!')
end


fclose(fid);
