function varargout = DIGESpotViewerGUI(varargin)
% DIGESPOTVIEWERGUI M-file for DIGESpotViewerGUI.fig
%      DIGESPOTVIEWERGUI, by itself, creates a new DIGESPOTVIEWERGUI or raises the existing
%      singleton*.
%
%      H = DIGESPOTVIEWERGUI returns the handle to a new DIGESPOTVIEWERGUI or the handle to
%      the existing singleton*.
%
%      DIGESPOTVIEWERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGESPOTVIEWERGUI.M with the given input arguments.
%
%      DIGESPOTVIEWERGUI('Property','Value',...) creates a new DIGESPOTVIEWERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DIGESpotViewerGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DIGESpotViewerGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DIGESpotViewerGUI

% Last Modified by GUIDE v2.5 27-Mar-2008 12:32:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DIGESpotViewerGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DIGESpotViewerGUI_OutputFcn, ...
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


% --- Executes just before DIGESpotViewerGUI is made visible.
function DIGESpotViewerGUI_OpeningFcn(hObject, eventdata, handles, varargin)
assignin('base','AnalysisToggle',0);
SpotUpdate(handles,1);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DIGESpotViewerGUI (see VARARGIN)

% Choose default command line output for DIGESpotViewerGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DIGESpotViewerGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DIGESpotViewerGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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


% --- Executes on button press in change.
function change_Callback(hObject, eventdata, handles)

% hObject    handle to change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
SpotUpdate(handles,round(get(handles.slider1,'Value')));

% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function CurrentSpotTxt_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentSpotTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentSpotTxt as text
%        str2double(get(hObject,'String')) returns contents of CurrentSpotTxt as a double


% --- Executes during object creation, after setting all properties.
function CurrentSpotTxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentSpotTxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
images=evalin('base','images');
summary=evalin('base','summary');
currentim=evalin('base','currentim');
xlist=evalin('base','xlist');
ylist=evalin('base','ylist');
if currentim=='Cy5'
    axes(handles.axes6);imagesc(log(images.Cy3orig));
    rectangle('EdgeColor','k','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
    assignin('base','currentim','Cy3');
else
    axes(handles.axes6);imagesc(log(images.Cy5orig)*summary.RatioMean);
    rectangle('EdgeColor','k','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
    assignin('base','currentim','Cy5');
end

% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
images=evalin('base','images');
summary=evalin('base','summary');
AnalysisToggle=evalin('base','AnalysisToggle');
axes(handles.axes6);
mask=roipoly;
set(handles.CurrentSpotTxt,'String','C');
[ylist,xlist]=find(mask==1);
%Cy3tmp=imcrop(images.FlatCy3,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
%Cy5tmp=imcrop(images.FlatCy5,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
if AnalysisToggle==0
    Cy3tmp=double(imcrop(images.FlatCy3,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]));
    Cy5tmp=double(imcrop(images.FlatCy5,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]));


    axes(handles.axes1);surf(Cy3tmp,'edgecolor','none');title('Cy3 spot');shading interp;drawnow;
    axes(handles.axes2); surf(Cy5tmp*summary.RatioMean,'edgecolor','none');title('Cy5 spot');shading interp;drawnow;
    axes(handles.axes3); surf(Cy3tmp-Cy5tmp*summary.RatioMean,'edgecolor','none');title('Cy3/Cy5 Ratio');shading interp;drawnow;
    randhist=normrnd(mean2(Cy3tmp)/mean2(Cy5tmp),summary.RatioStd,[1 length(summary.Ratios)]);
    disphist=vertcat(summary.Ratios,randhist);
    axes(handles.axes4);hist(disphist',100);
    assignin('base','xlist',xlist);
    assignin('base','ylist',ylist);
    assignin('base','currentim','Cy5');
else
    Cy3tmp=double(imcrop(images.Cy3orig,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]));
    Cy5tmp=double(imcrop(images.Cy5orig,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]));


    axes(handles.axes1);surf(Cy3tmp,'edgecolor','none');title('Cy3 spot');shading interp;drawnow;
    axes(handles.axes2); surf(Cy5tmp-summary.DiffMean,'edgecolor','none');title('Cy5 spot');shading interp;drawnow;
    axes(handles.axes3); surf(Cy3tmp-Cy5tmp-summary.DiffMean,'edgecolor','none');title('Cy3-Cy5 Difference');shading interp;drawnow;
    randhist=normrnd(mean2(Cy3tmp)/mean2(Cy5tmp),summary.DiffStd,[1 length(summary.Diffs)]);
    disphist=vertcat(summary.Diffs,randhist);
    axes(handles.axes4);hist(disphist',100);
    assignin('base','xlist',xlist);
    assignin('base','ylist',ylist);
    assignin('base','currentim','Cy5');
end

%v=axis;v(5)=-10;v(6)=10;axis(v);
axes(handles.axes6);imagesc(log(images.Cy5orig)*summary.RatioMean);
rectangle('EdgeColor','k','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)])

% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function SpotUpdate(handles,spotnum)
AnalysisToggle=evalin('base','AnalysisToggle');
if AnalysisToggle==0
    summary=evalin('base','summary');
    images=evalin('base','images');
    set(handles.CurrentSpotTxt,'String',round(get(handles.slider1,'Value')));
    set(handles.CurrentSpotRatio,'String',num2str(summary.Ratios(summary.RatioSigSpots(spotnum)),3));
    [ylist,xlist]=find(images.SpotDomains==summary.RatioSigSpots(spotnum));
    %Cy3tmp=imcrop(images.FlatCy3,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
    %Cy5tmp=imcrop(images.FlatCy5,[min(xlist) min(ylist) max(xlist)-min(xlist)
    %max(ylist)-min(ylist)]);

    Cy3tmp=imcrop(images.FlatCy3,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
    Cy5tmp=imcrop(images.FlatCy5,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);


    axes(handles.axes1);surf(Cy3tmp,'edgecolor','none');title('Cy3 spot');shading interp;
    axes(handles.axes2); surf(Cy5tmp*summary.RatioMean,'edgecolor','none');title('Normalized Cy5 spot');shading interp;
    axes(handles.axes3); surf(Cy3tmp./Cy5tmp,'edgecolor','none');title('Cy3/Cy5 Ratio');shading interp;
    randhist=normrnd(summary.Ratios(summary.RatioSigSpots(spotnum)),summary.RatioStd,[1 length(summary.Ratios)]);
    disphist=vertcat(summary.Ratios,randhist);
    axes(handles.axes4);hist(disphist',100);

    assignin('base','xlist',xlist);
    assignin('base','ylist',ylist);
    assignin('base','currentim','Cy5');
    %v=axis;v(5)=-10;v(6)=10;axis(v);
    axes(handles.axes6);imagesc(log(images.Cy5orig)*summary.RatioMean);
    assignin('base','currentim','Cy5');
    rectangle('EdgeColor','k','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)])


    set(handles.slider1,'Min',1,'Max',length(summary.RatioSigSpots),...
        'SliderStep',[1/length(summary.RatioSigSpots) 1/length(summary.RatioSigSpots)],'Value',spotnum);
else
    summary=evalin('base','summary');
    images=evalin('base','images');
    set(handles.CurrentSpotTxt,'String',round(get(handles.slider1,'Value')));
    set(handles.CurrentSpotRatio,'String',num2str(summary.Diffs(summary.DiffSigSpots(spotnum)),3));
    [ylist,xlist]=find(images.SpotDomains==summary.DiffSigSpots(spotnum));
    %Cy3tmp=imcrop(images.FlatCy3,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
    %Cy5tmp=imcrop(images.FlatCy5,[min(xlist) min(ylist) max(xlist)-min(xlist)
    %max(ylist)-min(ylist)]);

    Cy3tmp=imcrop(images.Cy3orig,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);
    Cy5tmp=imcrop(images.Cy5orig,[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);


    axes(handles.axes1);surf(Cy3tmp,'edgecolor','none');title('Cy3 spot');shading interp;
    axes(handles.axes2); surf(Cy5tmp+summary.DiffMean,'edgecolor','none');title('Normalized Cy5 spot');shading interp;
    axes(handles.axes3); surf(Cy3tmp-Cy5tmp,'edgecolor','none');title('Cy3-Cy5 Difference');shading interp;
    randhist=normrnd(summary.Diffs(summary.DiffSigSpots(spotnum)),summary.DiffStd,[1 length(summary.Diffs)]);
    disphist=vertcat(summary.Diffs,randhist);
    axes(handles.axes4);hist(disphist',100);

    assignin('base','xlist',xlist);
    assignin('base','ylist',ylist);
    assignin('base','currentim','Cy5');
    %v=axis;v(5)=-10;v(6)=10;axis(v);
    axes(handles.axes6);imagesc(log(images.Cy5orig)-summary.DiffMean);
    assignin('base','currentim','Cy5');
    rectangle('EdgeColor','k','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)])


    set(handles.slider1,'Min',1,'Max',length(summary.DiffSigSpots),...
        'SliderStep',[1/length(summary.DiffSigSpots) 1/length(summary.DiffSigSpots)],'Value',spotnum);
end


function CurrentSpotRatio_Callback(hObject, eventdata, handles)
% hObject    handle to CurrentSpotRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CurrentSpotRatio as text
%        str2double(get(hObject,'String')) returns contents of CurrentSpotRatio as a double


% --- Executes during object creation, after setting all properties.
function CurrentSpotRatio_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CurrentSpotRatio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RatioAnalysis.
function RatioAnalysis_Callback(hObject, eventdata, handles)
assignin('base','AnalysisToggle',0);
summary=evalin('base','summary');
set(handles.slider1,'Min',1,'Max',length(summary.RatioSigSpots),...
        'SliderStep',[1/length(summary.RatioSigSpots) 1/length(summary.RatioSigSpots)],'Value',1);
% hObject    handle to RatioAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RatioAnalysis


% --- Executes on button press in DiffAnalysis.
function DiffAnalysis_Callback(hObject, eventdata, handles)
assignin('base','AnalysisToggle',1);
summary=evalin('base','summary');
set(handles.slider1,'Min',1,'Max',length(summary.DiffSigSpots),...
        'SliderStep',[1/length(summary.DiffSigSpots) 1/length(summary.DiffSigSpots)],'Value',1);
% hObject    handle to DiffAnalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DiffAnalysis


