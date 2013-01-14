function varargout = stackviewRGB(varargin)
% STACKVIEW M-file for stackview.fig
%      STACKVIEW, by itself, creates a new STACKVIEW or raises the existing
%      singleton*.
%
%      H = STACKVIEW returns the handle to a new STACKVIEW or the handle to
%      the existing singleton*.
%
%      STACKVIEW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STACKVIEW.M with the given input arguments.
%
%      STACKVIEW('Property','Value',...) creates a new STACKVIEW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stackview_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stackview_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stackview

% Last Modified by GUIDE v2.5 08-Feb-2010 10:36:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stackview_OpeningFcn, ...
                   'gui_OutputFcn',  @stackview_OutputFcn, ...
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


% --- Executes just before stackview is made visible.
function stackview_OpeningFcn(hObject, eventdata, handles, varargin)
handles.stack=varargin{1};
axes(handles.axes1);imagesc(handles.stack(:,:,:,1));axis off;
guidata(hObject, handles);
handles.numim=size(handles.stack,4);
set(handles.ImageSlider,'Max',handles.numim,'Min',1,'SliderStep',[1/handles.numim 5/handles.numim],'Value',1);
set(handles.SliceEdit,'String',num2str(1));
set(handles.MaxEdit,'String',num2str(max(max(handles.stack(:,:,:,1)))));
set(handles.MinEdit,'String',num2str(min(min(handles.stack(:,:,:,1)))));
set(handles.MeanEdit,'String',num2str(mean2(handles.stack(:,:,:,1))));
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stackview (see VARARGIN)

% Choose default command line output for stackview
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes stackview wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stackview_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function ImageSlider_Callback(hObject, eventdata, handles)
Val=round(get(handles.ImageSlider,'Value'));
axes(handles.axes1);imagesc(handles.stack(:,:,:,Val));axis off;
disp(size(handles.stack));
set(handles.SliceEdit,'String',num2str(Val));
set(handles.MaxEdit,'String',num2str(max(max(handles.stack(:,:,:,Val)))));
set(handles.MinEdit,'String',num2str(min(min(handles.stack(:,:,:,Val)))));
set(handles.MeanEdit,'String',num2str(mean2(handles.stack(:,:,:,Val))));
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



function SliceEdit_Callback(hObject, eventdata, handles)
% hObject    handle to SliceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SliceEdit as text
%        str2double(get(hObject,'String')) returns contents of SliceEdit as a double


% --- Executes during object creation, after setting all properties.
function SliceEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SliceEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MaxEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MaxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxEdit as text
%        str2double(get(hObject,'String')) returns contents of MaxEdit as a double


% --- Executes during object creation, after setting all properties.
function MaxEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MinEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinEdit as text
%        str2double(get(hObject,'String')) returns contents of MinEdit as a double


% --- Executes during object creation, after setting all properties.
function MinEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MeanEdit_Callback(hObject, eventdata, handles)
% hObject    handle to MeanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MeanEdit as text
%        str2double(get(hObject,'String')) returns contents of MeanEdit as a double


% --- Executes during object creation, after setting all properties.
function MeanEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MeanEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Export.
function Export_Callback(hObject, eventdata, handles)
path=uigetdir;
for N=1:size(handles.stack,3)
    tmp=handles.stack(:,:,:,N);
    imwrite(tmp/max(tmp(:)),sprintf('%s/stackim%g.jpg',path,N));
end
% hObject    handle to Export (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
imdistline;
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


