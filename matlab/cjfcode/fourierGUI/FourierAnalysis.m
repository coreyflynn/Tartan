function varargout = FourierAnalysis(varargin)
% FOURIERANALYSIS M-file for FourierAnalysis.fig
%      FOURIERANALYSIS, by itself, creates a new FOURIERANALYSIS or raises the existing
%      singleton*.
%
%      H = FOURIERANALYSIS returns the handle to a new FOURIERANALYSIS or the handle to
%      the existing singleton*.
%
%      FOURIERANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FOURIERANALYSIS.M with the given input arguments.
%
%      FOURIERANALYSIS('Property','Value',...) creates a new FOURIERANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FourierAnalysis_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FourierAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FourierAnalysis

% Last Modified by GUIDE v2.5 01-Feb-2008 09:35:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FourierAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @FourierAnalysis_OutputFcn, ...
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


% --- Executes just before FourierAnalysis is made visible.
function FourierAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FourierAnalysis (see VARARGIN)

% Choose default command line output for FourierAnalysis
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FourierAnalysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FourierAnalysis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function BaseName_Callback(hObject, eventdata, handles)
% hObject    handle to BaseName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BaseName as text
%        str2double(get(hObject,'String')) returns contents of BaseName as a double


% --- Executes during object creation, after setting all properties.
function BaseName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BaseName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)

averagestack=evalin('base','averagestack');
savepath='/Users/jcrowley/Desktop/F07-269 analysis/';
axes(handles.axes1);
diff=(averagestack(:,:,1)+averagestack(:,:,19)/2)-(averagestack(:,:,10)+averagestack(:,:,28)/2);
set(handles.notes,'String','select an ROI to normilze over');
drawnow;
imagesc(diff);colormap(gray);caxis([-25 25]);
mask=roipoly;
orientationdiff=zeros(1024,1024,18);
directiondiff=zeros(1024,1024,36);

%%operate on the previosly generated averagestack to generate orientation
%%difference images.
for N=1:18
    tic;
    pos=(averagestack(:,:,N)+averagestack(:,:,N+18)/2);
    neg=(averagestack(:,:,mod(N+9,36)+1)+averagestack(:,:,mod(N+27,36)+1)/2);
    ratio=mean(pos(find(mask==1)))/mean(neg(find(mask==1)));
    pos=pos*ratio;
    diff=pos-neg;
    diff=diff-min(min(diff(find(mask==1))));
    diff(find(mask==0))=-1;
    orientationdiff(:,:,N)=diff;
    s=[savepath 'orientation mpp/F07-269_orientation' num2str(N)];
    cpp_write2(s,orientationdiff(:,:,N));
    axes(handles.axes1);imagesc(orientationdiff(:,:,N));colormap(gray);title(sprintf('(%d+%d)-(%d+%d)',N,N+18,N+9,N+27));
    set(handles.notes,'String',sprintf('processing %d0 degree image',N));
    set(handles.TimeLeft,'String',sprintf('%d sec',toc*(18-N)));
    drawnow;
end
assignin('base','orientationdiff',orientationdiff);
figure(1);
for N=1:18
    subplot(3,6,N);imagesc(orientationdiff(:,:,N));title(sprintf('(%d+%d)-(%d+%d)',N,N+18,N+9,N+27));
    colormap(gray);drawnow;
end

% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

set(handles.notes,'String','Starting Average Routine');
drawnow;
cycle=0;
averagestack=zeros(1024,1024,36);
stringbase=get(handles.BaseName,'String'); 
axes(handles.axes1);colormap(gray);
for N=36:324
      tic;
      if mod(N,36)==0
          oldfrac=cycle/(cycle+1);
          cycle=cycle+1;
      end
      s=[stringbase num2str(N) '.BLK'];
      tmp=blkread(s);
      averagestack(:,:,mod(N,36)+1)=averagestack(:,:,mod(N,36)+1)*oldfrac+mean(tmp.data,3)/cycle;
      imagesc(averagestack(:,:,mod(N,36)+1)-mean(averagestack,3));caxis([-25 25]);
      set(handles.notes,'String',sprintf('Adding to bin %d from cycle %d',mod(N,36)+1,cycle));
      set(handles.TimeLeft,'String',sprintf('%d min',toc*(324-N)/60));
      drawnow;
end
assignin('base','averagestack',averagestack);

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function notes_Callback(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of notes as text
%        str2double(get(hObject,'String')) returns contents of notes as a double


% --- Executes during object creation, after setting all properties.
function notes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to notes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)

luts=open('cjflut.mat');
axes(handles.axes1);colormap(luts.circle);
xmag=zeros(1024);
ymag=zeros(1024);
z=zeros(1024);
for N=1:18
tic;
s=['/Users/jcrowley/Desktop/F07-269 analysis/orientation mpp/F07-269_orientation' num2str(N)];
set(handles.notes,'String',sprintf('Processing %d0 degree image',N));
tmp=cpp_read2(s);
%imagesc(tmp);
xmag=xmag+tmp*cosd(20*N);
ymag=ymag+tmp*sind(20*N);
z=atan2(ymag,xmag)/2;
z=z/pi*180;
imagesc(z);colorbar;title('angle');
%colormap(circle);
set(handles.TimeLeft,'String',sprintf('%d sec',toc*(18-N)));
drawnow;
end
invert=find(z<0);
z(invert)=180+z(invert);
imagesc(z);colorbar;

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function TimeLeft_Callback(hObject, eventdata, handles)
% hObject    handle to TimeLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TimeLeft as text
%        str2double(get(hObject,'String')) returns contents of TimeLeft as a double


% --- Executes during object creation, after setting all properties.
function TimeLeft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TimeLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


