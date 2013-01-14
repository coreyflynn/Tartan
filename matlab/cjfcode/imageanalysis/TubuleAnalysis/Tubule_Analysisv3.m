function varargout = Tubule_Analysisv3(varargin)
% TUBULE_ANALYSIS M-file for Tubule_Analysis.fig
%      TUBULE_ANALYSIS, by itself, creates a new TUBULE_ANALYSIS or raises the existing
%      singleton*.
%
%      H = TUBULE_ANALYSIS returns the handle to a new TUBULE_ANALYSIS or the handle to
%      the existing singleton*.
%
%      TUBULE_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUBULE_ANALYSIS.M with the given input arguments.
%
%      TUBULE_ANALYSIS('Property','Value',...) creates a new TUBULE_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tubule_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tubule_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tubule_Analysis

% Last Modified by GUIDE v2.5 02-Jan-2009 16:45:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tubule_Analysis_OpeningFcn, ...
                   'gui_OutputFcn',  @Tubule_Analysis_OutputFcn, ...
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


% --- Executes just before Tubule_Analysis is made visible.
function Tubule_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
[handles.file,handles.dir]=uigetfile;
[handles.stack,handles.numim]=tiffread2(sprintf('%s%s',handles.dir,handles.file));
radius=str2num(get(handles.ShellRadEdit,'String'));
xy_res=.13;
z_res=.2;
radius=radius/xy_res;
bound=round(radius/z_res*xy_res);
set(handles.ImageSlider,'Max',handles.numim-bound,'Min',1+bound);
set(handles.ImageSlider,'SliderStep',[1/handles.numim 5/handles.numim],'Value',1+bound);
handles.x=[];
handles.y=[];
handles.z=[];
axes(handles.axes1);imagesc(handles.stack(1+bound).data);colormap(gray);axis off;
guidata(hObject, handles);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tubule_Analysis (see VARARGIN)

% Choose default command line output for Tubule_Analysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Tubule_Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Tubule_Analysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function ImageSlider_Callback(hObject, eventdata, handles)
Val=round(get(handles.ImageSlider,'Value'));
axes(handles.axes1);imagesc(handles.stack(Val).data);colormap(gray);axis off;
% hObject    handle to ImageSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function ImageSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in NewPath.
function NewPath_Callback(hObject, eventdata, handles)
[handles.file,handles.dir]=uigetfile;
[handles.stack,numim]=tiffread2(sprintf('%s%s',handles.dir,handles.file));
axes(handles.axes1);imagesc(handles.stack(68).data);colormap(gray);axis off;
guidata(hObject, handles);
% hObject    handle to NewPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in MarkCenter.
function MarkCenter_Callback(hObject, eventdata, handles)
Val=round(get(handles.ImageSlider,'Value'));
axes(handles.axes1);
[y,x]=ginput(1);
x=round(x);
y=round(y);
for N=1:11
    handles.stack(Val).data(x-6+N,y)=max(handles.stack(Val).data(:));
    handles.stack(Val).data(x,y-6+N)=max(handles.stack(Val).data(:));
end
imagesc(handles.stack(Val).data);colormap(gray);axis off;
guidata(hObject, handles);
handles.x=horzcat(handles.x,x);
handles.y=horzcat(handles.y,y);
handles.z=horzcat(handles.z,Val);
guidata(hObject, handles);
% hObject    handle to MarkCenter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in RunAnalysis.
function RunAnalysis_Callback(hObject, eventdata, handles)
xy_res=.13; %um/pixel
z_res=.2; %um/pixel
thresh=str2num(get(handles.ThreshEdit,'String'));
radius=str2num(get(handles.ShellRadEdit,'String'));
thickness=str2num(get(handles.ShellThickEdit,'String'));
radius=radius/xy_res;
thickness=thickness/xy_res;
X=repmat((1:696),520,1);
Y=repmat((1:520)',1,696);
slide_pos=round(get(handles.ImageSlider,'Value'));
disp('Running Analysis');
bound=round(radius/z_res*xy_res);
for N=1:length(handles.x)
    %result{N}=[];
    count=0;
    for M=handles.z(N)-round(radius/z_res*xy_res):handles.z(N)+round(radius/z_res*xy_res)
    count=count+1;
    if M>1+bound && M<handles.numim-bound
        set(handles.ImageSlider,'Value',M);
    end
    mask=get_mask(X,Y,handles.x(N),handles.y(N),handles.z(N),...
        M,radius,z_res,thickness,[handles.stack(1).height handles.stack(1).width]);
    tmp=handles.stack(M).data;
    tmp=tmp/max(tmp(:));
    bw=im2bw(tmp,thresh);
    labeled=bwlabel(bw.*mask);
    bw=double(bw);
    bw(mask==1)=2;
    axes(handles.axes1);imagesc(bw);axis off;drawnow;
    %result{N}=horzcat(result{N},max(labeled(:)));
    result(N,count)=max(labeled(:));
    end
    %disp(sprintf('Found an average of %g tubules at location %g',mean(result{N},2),N));
    disp(sprintf('Found an average of %g tubules at location %g',mean(result(N,:),2),N));
end
set(handles.ImageSlider,'Value',slide_pos);
axes(handles.axes1);imagesc(handles.stack(round(get(handles.ImageSlider,'Value'))).data);
drawnow;axis off;
if length(handles.x)>=1
    xlswrite(sprintf('%s%s_%grad_%gthick.csv',handles.dir,...
    handles.file(1:length(handles.file)-4),radius*xy_res,thickness*xy_res),result');
else
    disp('No Marked Centers to Analyze');
end
% hObject    handle to RunAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function mask=get_mask(X,Y,y,x,z,slice,radius,z_res,thickness,imsize)
radius=radius*.13;
z_component=abs(z-slice)*z_res;
new_radius=sqrt(radius^2-z_component^2)/.13;
mask=zeros(imsize(1),imsize(2));
mask(sqrt((X-x).^2+(Y-y).^2)<new_radius)=1;
mask(sqrt((X-x).^2+(Y-y).^2)<new_radius-thickness)=0;
assignin('base','mask2',mask);



function ShellRadEdit_Callback(hObject, eventdata, handles)
xy_res=.13;
z_res=.2;
radius=str2num(get(handles.ShellRadEdit,'String'));
radius=radius/xy_res;
bound=round(radius/z_res*xy_res);
set(handles.ImageSlider,'Max',handles.numim-bound,'Min',1+bound,'Value',1+bound);
axes(handles.axes1);imagesc(handles.stack(1+bound).data);axis off;
% hObject    handle to ShellRadEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ShellRadEdit as text
%        str2double(get(hObject,'String')) returns contents of ShellRadEdit as a double


% --- Executes during object creation, after setting all properties.
function ShellRadEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShellRadEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ShellThickEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ShellThickEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ShellThickEdit as text
%        str2double(get(hObject,'String')) returns contents of ShellThickEdit as a double


% --- Executes during object creation, after setting all properties.
function ShellThickEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ShellThickEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ThreshEdit_Callback(hObject, eventdata, handles)
% hObject    handle to ThreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ThreshEdit as text
%        str2double(get(hObject,'String')) returns contents of ThreshEdit as a double


% --- Executes during object creation, after setting all properties.
function ThreshEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ThreshEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ClearCenters.
function ClearCenters_Callback(hObject, eventdata, handles)
handles.x=[];
handles.y=[];
handles.z=[];
guidata(hObject,handles);
% hObject    handle to ClearCenters (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


