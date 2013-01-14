function varargout = mppconverter(varargin)
% MPPCONVERTER M-file for mppconverter.fig
%      MPPCONVERTER, by itself, creates a new MPPCONVERTER or raises the existing
%      singleton*.
%
%      H = MPPCONVERTER returns the handle to a new MPPCONVERTER or the handle to
%      the existing singleton*.
%
%      MPPCONVERTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MPPCONVERTER.M with the given input arguments.
%
%      MPPCONVERTER('Property','Value',...) creates a new MPPCONVERTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before mppconverter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to mppconverter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help mppconverter

% Last Modified by GUIDE v2.5 23-Nov-2008 12:38:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @mppconverter_OpeningFcn, ...
                   'gui_OutputFcn',  @mppconverter_OutputFcn, ...
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


% --- Executes just before mppconverter is made visible.
function mppconverter_OpeningFcn(hObject, eventdata, handles, varargin)
axis(handles.axes1);axis off;
handles.bincondition=1;
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to mppconverter (see VARARGIN)

% Choose default command line output for mppconverter
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes mppconverter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = mppconverter_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
handles.currentpath=uigetdir;
set(handles.InputPath,'String',handles.currentpath);
set(handles.OutputPath,'String',sprintf('%s/cpp_files',handles.currentpath));
guidata(hObject, handles);

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in convertbutton.
function convertbutton_Callback(hObject, eventdata, handles)
files=dir(fullfile(handles.currentpath,'Data*.BLK'));
if isdir(get(handles.OutputPath,'String'))==1
    set(handles.status,'String','Checking Directories');drawnow;
else
    mkdir(get(handles.OutputPath,'String'));
    set(handles.status,'String','Checking Directories');drawnow;
end
savepath=get(handles.OutputPath,'String');
count=1;
progress=zeros(length(files),1);
for N=1:length(files)
     set(handles.status,'String',sprintf('Reading Block %g of %g',N,length(files)));drawnow;
    tmp=blkread_longdaq(sprintf('%s/%s',handles.currentpath,files(N).name));
    for M=1:handles.bincondition:10
        set(handles.status,'String',...
            sprintf('Writing Image %g of %g',(N-1)*10/handles.bincondition+M...
            ,length(files)*10/handles.bincondition));
        drawnow;
        cpp_write2(sprintf('%s/Image%g.cpp',savepath,count)...
            ,sum(tmp.data(:,:,M:M+handles.bincondition-1),3));
        count=count+1;
    end
    progress(1:N,1)=1;
    axis(handles.axes1);imagesc(progress);axis off;
end
        
% hObject    handle to convertbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function status_Callback(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of status as text
%        str2double(get(hObject,'String')) returns contents of status as a double


% --- Executes during object creation, after setting all properties.
function status_CreateFcn(hObject, eventdata, handles)
% hObject    handle to status (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in binpopup.
function binpopup_Callback(hObject, eventdata, handles)
Val=get(handles.binpopup,'Value');
switch Val
    case 1
        handles.bincondition=1;
    case 2
        handles.bincondition=2;
    case 3
        handles.bincondition=5;
    case 4
        handles.bincondition=10;
end
guidata(hObject, handles);
% hObject    handle to binpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns binpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from binpopup


% --- Executes during object creation, after setting all properties.
function binpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to binpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


