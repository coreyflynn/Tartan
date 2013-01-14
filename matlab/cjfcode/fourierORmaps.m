function varargout = fourierORmaps(varargin)
% FOURIERORMAPS M-file for fourierORmaps.fig
%      FOURIERORMAPS, by itself, creates a new FOURIERORMAPS or raises the existing
%      singleton*.
%
%      H = FOURIERORMAPS returns the handle to a new FOURIERORMAPS or the handle to
%      the existing singleton*.
%
%      FOURIERORMAPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOURIERORMAPS.M with the given input arguments.
%
%      FOURIERORMAPS('Property','Value',...) creates a new FOURIERORMAPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fourierORmaps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fourierORmaps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fourierORmaps

% Last Modified by GUIDE v2.5 01-Dec-2008 22:24:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fourierORmaps_OpeningFcn, ...
                   'gui_OutputFcn',  @fourierORmaps_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fourierORmaps is made visible.
function fourierORmaps_OpeningFcn(hObject, eventdata, handles, varargin)
handles.Filter=1;
handles.Clipping=1;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fourierORmaps (see VARARGIN)

% Choose default command line output for fourierORmaps
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fourierORmaps wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fourierORmaps_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function InputPath_Callback(hObject, eventdata, handles)
% hObject    handle to InputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of InputPath as text
%        str2double(get(hObject,'String')) returns contents of InputPath as a double


% --- Executes during object creation, after setting all properties.
function InputPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to InputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ChangeInput.
function ChangeInput_Callback(hObject, eventdata, handles)
handles.InputPathString=uigetdir;
set(handles.InputPath,'String',handles.InputPathString);
set(handles.OutputPath,'String',...
    sprintf('%s/fourierORmaps_output',handles.InputPathString));
guidata(hObject, handles);
% hObject    handle to ChangeInput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in GenerateMaps.
function GenerateMaps_Callback(hObject, eventdata, handles)
if isdir(get(handles.OutputPath,'String'))==0
    mkdir(get(handles.OutputPath,'String'));
end
path=get(handles.InputPath,'String');
pos=zeros(1024,1024);
pos2=zeros(1024,1024);
neg=zeros(1024,1024);
neg2=zeros(1024,1024);
xmag=zeros(1024);
ymag=zeros(1024);
xmagsum=zeros(1024);
ymagsum=zeros(1024);
z=zeros(1024);
cmaps=open('cjflut.mat');
start=str2double(get(handles.StartImage,'String'));
stop=str2double(get(handles.EndImage,'String'));
cycle=1;
first_flag=1;
for N=start:stop
    pos(:,:)=cpp_read2(sprintf('%s/Image%g.cpp',path,N));
    pos2(:,:)=cpp_read2(sprintf('%s/Image%g.cpp',path,N+18));
    neg(:,:)=cpp_read2(sprintf('%s/Image%g.cpp',path,N+9));
    neg2(:,:)=cpp_read2(sprintf('%s/Image%g.cpp',path,N+27));
   
%     pos(:,:)=imread(sprintf('%s/%g.jpg',path,N));
%     pos2(:,:)=imread(sprintf('%s/%g.jpg',path,N+18));
%     neg(:,:)=imread(sprintf('%s/%g.jpg',path,N+9));
%     neg2(:,:)=imread(sprintf('%s/%g.jpg',path,N+27));
    angle=(N*20);
    posOR=pos+pos2;
    negOR=neg+neg2;
    %ratio=mean(posOR(410:610,410:610))/mean(negOR(410:610,410:610));
    %posOR=posOR*ratio;
    diff=posOR-(posOR+negOR)/2;
    if first_flag==1
        h=figure;imagesc(diff);colormap(gray);title('Choose ROI for Analysis');
        mask=roipoly;
        close(h);
        first_flag=0;
    end
    if handles.Clipping==1    
        diff=clipped_data(diff,str2num(get(handles.ClipVal,'String')),mask);
    end
    if handles.Filter==1
        kernel_size=str2num(get(handles.Kernel_edit,'String'));
        diff=medfilt2(diff,[kernel_size kernel_size]);
    end
    cfstring=sprintf('%gclip%gfilter',...
        str2num(get(handles.ClipVal,'String')),...
        str2num(get(handles.Kernel_edit,'String')));
    if get(handles.save_diff,'Value')==1
        diff_scale=(diff-min(diff(:)));
        diff_scale=diff_scale/max(diff_scale(:))*255;
        imwrite(uint8(diff_scale),sprintf('%s/diffmap%g.tif',...
            get(handles.OutputPath,'String'),N),'Compression','none');
    end
    
    xmag=xmag+diff*cosd(angle);
    ymag=ymag+diff*sind(angle);
    z=atan2(ymag,xmag)/2;
    z=z/pi*180+90;
    
    m=64;
    cmin=min(diff(:));
    cmax=max(diff(:));
    C1 = min(m,round((m-1)*(diff-cmin)/(cmax-cmin))+1);C1(mask==0)=0;
    cmin=min(z(:));
    cmax=max(z(:));
    C2 = min(m,round((m-1)*(z-cmin)/(cmax-cmin))+1);
    C2=C2+64;C2(mask==0)=0;
    if mod(N,18)==0
    %if mod(N-start+1,18)==0
        xmagsum=xmagsum+xmag;
        ymagsum=ymagsum+ymag;
        zsum=atan2(ymagsum,xmagsum)/2;
        zsum=zsum/pi*180+90;
        cmin=min(zsum(:));
        cmax=max(zsum(:));
        C3 = min(m,round((m-1)*(zsum-cmin)/(cmax-cmin))+1);
        C3=C3+64;C3(mask==0)=0;
        axes(handles.aveangleim);image(C3);axis off;drawnow;
        if get(handles.save_ind,'Value')==1
            cpp_write2(sprintf('%s/anglemap%g.cpp',...
                get(handles.OutputPath,'String'),cycle),z);
            cpp_write2(sprintf('%s/xmagmap%g.cpp',...
                get(handles.OutputPath,'String'),cycle),xmag);
            cpp_write2(sprintf('%s/ymagmap%g.cpp',...
                get(handles.OutputPath,'String'),cycle),ymag);
        end
        xmag=zeros(1024,1024);
        ymag=zeros(1024,1024);
        cycle=cycle+1;
    end
    axes(handles.currentdiffim);image(C1);axis off;drawnow;
    %Movie1(N-1)=getframe(gcf);
    %clipped_display(handles.currentdiffim,C1,2);colorbar;
    axes(handles.currentangleim);
    cmap=[gray(64);cmaps.cjflut.circle];
    image(C2);colormap(cmap);axis off;drawnow;
end
if get(handles.save_final,'Value')==1
    C3(1000:1010,853:1010)=64;
    figure;image(C3);colormap(cmap);truesize;colorbar;
    saveas(gcf,sprintf('%s/aveanglemap_%s.jpg',...
        get(handles.OutputPath,'String'),...
        cfstring));
    cpp_write2(sprintf('%s/aveanglemap.cpp',...
        get(handles.OutputPath,'String'),zsum));
end
%assignin('base','Movie1',Movie1);
% hObject    handle to GenerateMaps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function out=clipped_data(data,clip_val,mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    This function is used to draw a matix into the specified axis.  The 
%    clipping value of the image as displayed is set at the user specified 
%    clip val.  clip_val_edit is the number of standard deviations from the mean
%    at which we will set the black and white values of the image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmpmean=mean2(data(mask==1));
tmpstd=std2(data(mask==1));
out=data;
out(out<tmpmean-clip_val*tmpstd)=tmpmean-clip_val*tmpstd;
out(out>tmpmean+clip_val*tmpstd)=tmpmean+clip_val*tmpstd;
out=out.*mask;



function OutputPath_Callback(hObject, eventdata, handles)
% hObject    handle to OutputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputPath as text
%        str2double(get(hObject,'String')) returns contents of OutputPath as a double


% --- Executes during object creation, after setting all properties.
function OutputPath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ChangeOutput.
function ChangeOutput_Callback(hObject, eventdata, handles)
handles.OutputPathString=uigetdir;
set(handles.OutputPath,'String',handles.OutputPathString);
% hObject    handle to ChangeOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in FilterOff.
function FilterOff_Callback(hObject, eventdata, handles)
% hObject    handle to FilterOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FilterOff


% --- Executes when selected object is changed in FilterPanel.
function FilterPanel_SelectionChangeFcn(hObject, eventdata, handles)
Val(1)=get(handles.FilterOn,'Value');
Val(2)=get(handles.FilterOff,'Value');
switch find(Val);
    case 1
        disp('Filter on');
        handles.Filter=1;
        set(handles.Kernel_edit,'String',handles.lastKernel);
    case 2
        disp('Filter off');
        handles.Filter=0;
        set(handles.Kernel_edit,'String','0');
end
guidata(hObject, handles);
% hObject    handle to the selected object in FilterPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)



function Kernel_edit_Callback(hObject, eventdata, handles)
handles.lastKernel=get(handles.Kernel_edit,'String');
guidata(hObject, handles);
% hObject    handle to Kernel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Kernel_edit as text
%        str2double(get(hObject,'String')) returns contents of Kernel_edit as a double


% --- Executes during object creation, after setting all properties.
function Kernel_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Kernel_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in ClipPanel.
function ClipPanel_SelectionChangeFcn(hObject, eventdata, handles)
Val(1)=get(handles.ClippingOn,'Value');
Val(2)=get(handles.ClippingOff,'Value');
switch find(Val);
    case 1
        disp('Clipping on');
        handles.Clipping=1;
        set(handles.ClipVal,'String',handles.lastClipVal);
    case 2
        disp('Clipping off');
        handles.Clipping=0;
        set(handles.ClipVal,'String','0');
end
guidata(hObject, handles);
% hObject    handle to the selected object in ClipPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)



function ClipVal_Callback(hObject, eventdata, handles)
handles.lastClipVal=get(handles.ClipVal,'String');
guidata(hObject, handles);
% hObject    handle to ClipVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ClipVal as text
%        str2double(get(hObject,'String')) returns contents of ClipVal as a double


% --- Executes during object creation, after setting all properties.
function ClipVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ClipVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClippingOff.
function ClippingOff_Callback(hObject, eventdata, handles)
% hObject    handle to ClippingOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ClippingOff



function EndImage_Callback(hObject, eventdata, handles)
% hObject    handle to EndImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EndImage as text
%        str2double(get(hObject,'String')) returns contents of EndImage as a double


% --- Executes during object creation, after setting all properties.
function EndImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EndImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StartImage_Callback(hObject, eventdata, handles)
% hObject    handle to StartImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartImage as text
%        str2double(get(hObject,'String')) returns contents of StartImage as a double


% --- Executes during object creation, after setting all properties.
function StartImage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartImage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_final.
function save_final_Callback(hObject, eventdata, handles)
% hObject    handle to save_final (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_final


% --- Executes on button press in save_ind.
function save_ind_Callback(hObject, eventdata, handles)
% hObject    handle to save_ind (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_ind


% --- Executes on button press in save_diff.
function save_diff_Callback(hObject, eventdata, handles)
% hObject    handle to save_diff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_diff


