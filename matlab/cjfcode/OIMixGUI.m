function varargout = OIMixGUI(varargin)
% OIMIXGUI M-file for OIMixGUI.fig
%      OIMIXGUI, by itself, creates a new OIMIXGUI or raises the existing
%      singleton*.
%
%      H = OIMIXGUI returns the handle to a new OIMIXGUI or the handle to
%      the existing singleton*.
%
%      OIMIXGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OIMIXGUI.M with the given input arguments.
%
%      OIMIXGUI('Property','Value',...) creates a new OIMIXGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OIMixGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OIMixGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OIMixGUI

% Last Modified by GUIDE v2.5 01-Aug-2008 11:21:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OIMixGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @OIMixGUI_OutputFcn, ...
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


% --- Executes just before OIMixGUI is made visible.
function OIMixGUI_OpeningFcn(hObject, eventdata, handles, varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    turn off the axis tick marks on all axes used to display images     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for N=1:16
    s=eval(sprintf('handles.axes%d',N));
    axes(s);axis off;
end
axes(handles.currentaxes);axis off;
axes(handles.sumaxes);axis off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Set all frames to active by default     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for N=1:5
    s=eval(sprintf('handles.frame%dtoggle',N));
    set(s,'Value',1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Set all blocks to active by default     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for N=1:16
    s=eval(sprintf('handles.block%dtoggle',N));
    set(s,'Value',1);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Store the active blocks and frames to memory     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.frame_state=ones(1,5);
handles.block_state=ones(1,16);
handles.active_frames=1:5;
handles.active_blocks=1:16;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Set the clipping value for display to 2 by default     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
handles.clip=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Update the handle structure    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%guidata(hObject, handles);
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OIMixGUI (see VARARGIN)

% Choose default command line output for OIMixGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OIMixGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OIMixGUI_OutputFcn(hObject, eventdata, handles) 
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



function path_Callback(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path as text
%        str2double(get(hObject,'String')) returns contents of path as a double


% --- Executes during object creation, after setting all properties.
function path_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in path_change.
function path_change_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    grab the file path to operate on from a UI dialog    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startpath=get(handles.path,'String');
if isdir(startpath)==1
    path=uigetdir(startpath,'Select Data Path');
else
    path=uigetdir('','Select Data Path');
end
set(handles.path,'String',[path '/']);

% hObject    handle to path_change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over path_change.
function path_change_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to path_change (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function startbox_Callback(hObject, eventdata, handles)
% hObject    handle to startbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of startbox as text
%        str2double(get(hObject,'String')) returns contents of startbox as a double


% --- Executes during object creation, after setting all properties.
function startbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endbox_Callback(hObject, eventdata, handles)
% hObject    handle to endbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endbox as text
%        str2double(get(hObject,'String')) returns contents of endbox as a double


% --- Executes during object creation, after setting all properties.
function endbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in process_data.
function process_data_Callback(hObject, eventdata, handles)
data_import(hObject,handles);

% hObject    handle to process_data (see GCBO)
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
data_import(hObject,handles);

% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Grab the selected image from the pulldown menu and draw it to the 
%    current image axis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');

val=get(handles.popupmenu1,'Value');
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.currentaxes,FullOD(:,:,val),handles.clip);
else
    clipped_display(handles.currentaxes,FullOR(:,:,val),handles.clip);
end
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

function clipped_display(input_axis,data,clip_val)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    This function is used to draw a matix into the specified axis.  The 
%    clipping value of the image as displayed is set at the user specified 
%    clip val.  clip_val_edit is the number of standard deviations from the mean
%    at which we will set the black and white values of the image.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
axes(input_axis);imagesc(data);colormap(gray);axis off;
tmpmean=mean2(data(410:610,410:610));
tmpstd=std2(data(410:610,410:610));
caxis([tmpmean-clip_val*tmpstd tmpmean+clip_val*tmpstd]);drawnow;


% --- Executes on selection change in popupmenu2.

function popupmenu2_Callback(hObject, eventdata, handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Switches between OD and OR maps.  When the maps are switched, all of
%    images are redisplayed from either FullOD or FullOR.
%    the active blocks are reset to those blocks that are specified by the
%    user.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.popupmenu2,'Value');
startval=str2double(get(handles.startbox,'String'));
endval=str2double(get(handles.endbox,'String'));
switch val
    case 1
        for N=startval:endval
            set(handles.status,'String',sprintf('Switching to Block %d Ocular Dominance Map',N));drawnow;
            s=eval(sprintf('handles.axes%d',N));
            clipped_display(s,FullOD(:,:,N),handles.clip);
            clipped_display(handles.currentaxes,FullOD(:,:,N),handles.clip);
            set(handles.popupmenu1,'Value',N);drawnow;
            clipped_display(handles.sumaxes,sum(FullOD(:,:,startval:N),3),handles.clip);
        end
        handles.map_switch='OD';
    case 2
        for N=startval:endval
            set(handles.status,'String',sprintf('Switching to Block %d Orientation Map',N));drawnow;
            s=eval(sprintf('handles.axes%d',N));
            clipped_display(s,FullOR(:,:,N),handles.clip);
            clipped_display(handles.currentaxes,FullOR(:,:,N),handles.clip);
            set(handles.popupmenu1,'Value',N);drawnow;
            clipped_display(handles.sumaxes,sum(FullOR(:,:,startval:N),3),handles.clip);
        end
        handles.map_switch='OR';
end
for N=startval:endval
    s=eval(sprintf('handles.block%dtoggle',N));
    set(s,'Value',1);
end
set(handles.status,'String','Resetting Active Blocks');drawnow;
handles.block_state=ones(1,16);
handles.active_blocks=1:16;
set(handles.status,'String','Done!');
guidata(hObject,handles);
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


% --- Executes on button press in frame1toggle.
function frame1toggle_Callback(hObject, eventdata, handles)
val=get(handles.frame1toggle,'Value');
if val==1
    handles.frame_state(1)=1;
else
    handles.frame_state(1)=0;
end
handles.active_frames=find(handles.frame_state==1);
guidata(hObject, handles);
% hObject    handle to frame1toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frame1toggle


% --- Executes on button press in frame2toggle.
function frame2toggle_Callback(hObject, eventdata, handles)
val=get(handles.frame2toggle,'Value');
if val==1
    handles.frame_state(2)=1;
else
    handles.frame_state(2)=0;
end
handles.active_frames=find(handles.frame_state==1);
guidata(hObject, handles);
% hObject    handle to frame2toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frame2toggle


% --- Executes on button press in frame3toggle.
function frame3toggle_Callback(hObject, eventdata, handles)
val=get(handles.frame3toggle,'Value');
if val==1
    handles.frame_state(3)=1;
else
    handles.frame_state(3)=0;
end
handles.active_frames=find(handles.frame_state==1);
guidata(hObject, handles);
% hObject    handle to frame3toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frame3toggle


% --- Executes on button press in frame4toggle.
function frame4toggle_Callback(hObject, eventdata, handles)
val=get(handles.frame4toggle,'Value');
if val==1
    handles.frame_state(4)=1;
else
    handles.frame_state(4)=0;
end
handles.active_frames=find(handles.frame_state==1);
guidata(hObject, handles);
% hObject    handle to frame4toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frame4toggle


% --- Executes on button press in frame5toggle.
function frame5toggle_Callback(hObject, eventdata, handles)
val=get(handles.frame5toggle,'Value');
if val==1
    handles.frame_state(5)=1;
else
    handles.frame_state(5)=0;
end
handles.active_frames=find(handles.frame_state==1);
guidata(hObject, handles);
% hObject    handle to frame5toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of frame5toggle


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
FramesOD=evalin('base','FramesOD');
FramesOR=evalin('base','FramesOR');
figure;
for N=1:5
    subplot(2,5,N);clipped_display(gca,FramesOD(:,:,N),handles.clip);title(sprintf('OD frame %g',N));colormap(gray);
    subplot(2,5,N+5);clipped_display(gca,FramesOR(:,:,N),handles.clip);title(sprintf('OR frame %g',N));colormap(gray);
    drawnow;
end
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in block1toggle.
function block1toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block1toggle,'Value');
if val==1
    handles.block_state(1)=1;
else
    handles.block_state(1)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block1toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block1toggle


% --- Executes on button press in block2toggle.
function block2toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block2toggle,'Value');
if val==1
    handles.block_state(2)=1;
else
    handles.block_state(2)=0;
end
handles.active_blocks=find(handles.block_state==1);
disp(handles.active_blocks);
size(FullOD)
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block2toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block2toggle


% --- Executes on button press in block3toggle.
function block3toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block3toggle,'Value');
if val==1
    handles.block_state(3)=1;
else
    handles.block_state(3)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block3toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block3toggle


% --- Executes on button press in block4toggle.
function block4toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block4toggle,'Value');
if val==1
    handles.block_state(4)=1;
else
    handles.block_state(4)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block4toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block4toggle


% --- Executes on button press in block5toggle.
function block5toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block5toggle,'Value');
if val==1
    handles.block_state(5)=1;
else
    handles.block_state(5)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block5toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block5toggle


% --- Executes on button press in block6toggle.
function block6toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block6toggle,'Value');
if val==1
    handles.block_state(6)=1;
else
    handles.block_state(6)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block6toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block6toggle


% --- Executes on button press in block8toggle.
function block8toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block8toggle,'Value');
if val==1
    handles.block_state(8)=1;
else
    handles.block_state(8)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block8toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block8toggle


% --- Executes on button press in block9toggle.
function block9toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block9toggle,'Value');
if val==1
    handles.block_state(9)=1;
else
    handles.block_state(9)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block9toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block9toggle


% --- Executes on button press in block10toggle.
function block10toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block10toggle,'Value');
if val==1
    handles.block_state(10)=1;
else
    handles.block_state(10)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block10toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block10toggle


% --- Executes on button press in block11toggle.
function block11toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block11toggle,'Value');
if val==1
    handles.block_state(11)=1;
else
    handles.block_state(11)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block11toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block11toggle


% --- Executes on button press in block12toggle.
function block12toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block12toggle,'Value');
if val==1
    handles.block_state(12)=1;
else
    handles.block_state(12)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block12toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block12toggle


% --- Executes on button press in block14toggle.
function block14toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block14toggle,'Value');
if val==1
    handles.block_state(14)=1;
else
    handles.block_state(14)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block14toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block14toggle


% --- Executes on button press in block15toggle.
function block15toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block15toggle,'Value');
if val==1
    handles.block_state(15)=1;
else
    handles.block_state(15)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block15toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block15toggle


% --- Executes on button press in block16toggle.
function block16toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block16toggle,'Value');
if val==1
    handles.block_state(16)=1;
else
    handles.block_state(16)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block16toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block16toggle


% --- Executes on button press in block7toggle.
function block7toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block7toggle,'Value');
if val==1
    handles.block_state(7)=1;
else
    handles.block_state(7)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block7toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block7toggle


% --- Executes on button press in block13toggle.
function block13toggle_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
val=get(handles.block3toggle,'Value');
if val==1
    handles.block_state(13)=1;
else
    handles.block_state(13)=0;
end
handles.active_blocks=find(handles.block_state==1);
if strcmp(handles.map_switch,'OD')==1
    clipped_display(handles.sumaxes,sum(FullOD(:,:,handles.active_blocks),3),handles.clip);
else
    clipped_display(handles.sumaxes,sum(FullOR(:,:,handles.active_blocks),3),handles.clip);
end
guidata(hObject, handles);
% hObject    handle to block13toggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of block13toggle



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function data_import(hObject,handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    This function is the main point of entry for new data.  Based on the 
%    file path information that the user has specified, we will import .BLK
%    files according to the current state of the active frames and blocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startval=str2double(get(handles.startbox,'String'));
endval=str2double(get(handles.endbox,'String'));
handles.clip=str2double(get(handles.clip_val_edit,'String'));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Update the block toggle buttons based on the users inputted start and
%    end block values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for N=1:16
    s=eval(sprintf('handles.block%dtoggle',N));
    if N<startval || N>endval
        set(s,'Value',0);
        handles.block_state(N)=0;
    else
        set(s,'Value',1);
        handles.block_state(N)=1;
    end
end
handles.active_blocks=find(handles.block_state==1);
path=get(handles.path,'String');
expnum=str2double(get(handles.edit6,'String'));
expnum
if expnum<10
    expstring=sprintf('cjf_E00%g',expnum);
else
    expstring=sprintf('cjf_E0%g',expnum);
end
expstring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    create dummy matrices to fill with data and clear all block axis   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
evalin('base','clear all');
FramesOD=zeros(1020,1020,5);
FramesOR=zeros(1020,1020,5);
FullOD=zeros(1020,1020,16);
FullOR=zeros(1020,1020,16);
for N=1:16
    s=eval(sprintf('handles.axes%d',N));
    axes(s);imagesc(FullOD(:,:,1));axis off;drawnow;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Import all the specified blocks and calculate their OD and OR maps    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for N=startval:endval
    set(handles.status,'String',sprintf('Reading Block #%d',N));drawnow;
    if N<11
        s=(sprintf('%s%sB0%d.BLK',path,expstring,N-1));
    else
        s=(sprintf('%s%sB%d.BLK',path,expstring,N-1));
    end
    tmp=blkread_vdaq(s);
    set(handles.status,'String',sprintf('Calculating Block #%d Frames',N));drawnow;
    for M=1:5
    FramesOD(:,:,M)=tmp.data(:,:,2,M)+tmp.data(:,:,3,M)...
        -tmp.data(:,:,4,M)-tmp.data(:,:,5,M);
    FramesOR(:,:,M)=tmp.data(:,:,2,M)-tmp.data(:,:,3,M)...
        +tmp.data(:,:,4,M)-tmp.data(:,:,5,M);
    end
    set(handles.status,'String',sprintf('Calculating Block #%d Map',N));drawnow;
    %calculate the current block's OD map
    tmpOD=sum(tmp.data(:,:,2,handles.active_frames),4)+sum(tmp.data(:,:,3,handles.active_frames),4)...
        -sum(tmp.data(:,:,4,handles.active_frames),4)-sum(tmp.data(:,:,5,handles.active_frames),4);
    %calculate the current block's OR map
    tmpOR=sum(tmp.data(:,:,2,handles.active_frames),4)-sum(tmp.data(:,:,3,handles.active_frames),4)...
        +sum(tmp.data(:,:,4,handles.active_frames),4)-sum(tmp.data(:,:,5,handles.active_frames),4);
    set(handles.status,'String','Calculating Summed Map');drawnow;
    %store the OD and OR maps into the dummy matrices set up above
    FullOD(:,:,N)=FullOD(:,:,N)+tmpOD;
    FullOR(:,:,N)=FullOR(:,:,N)+tmpOR;
    %calculate the summed image and store to memory
    handles.sumimage=sum(FullOD,3);
    %draw images to the appropriate axes
    clipped_display(handles.sumaxes,handles.sumimage,handles.clip);
    s=eval(sprintf('handles.axes%d',N));
    clipped_display(s,tmpOD,handles.clip);
    clipped_display(handles.currentaxes,tmpOD,handles.clip);
    set(handles.popupmenu1,'Value',N);
    clear tmp;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finish up by drawing the final images, writing the data files to the base
% workspace, and updating the handles structure.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.status,'String','Done!');drawnow;
clipped_display(handles.currentaxes,FullOD(:,:,1),handles.clip);
handles.map_switch='OD';
set(handles.popupmenu2,'Value',1);
guidata(hObject, handles);
assignin('base','FramesOD',FramesOD);
assignin('base','FramesOR',FramesOR);
assignin('base','FullOD',FullOD);
assignin('base','FullOR',FullOR);



function clip_val_edit_Callback(hObject, eventdata, handles)

% hObject    handle to clip_val_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of clip_val_edit as text
%        str2double(get(hObject,'String')) returns contents of clip_val_edit as a double


% --- Executes during object creation, after setting all properties.
function clip_val_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clip_val_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clip_display.
function clip_display_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
startval=str2double(get(handles.startbox,'String'));
endval=str2double(get(handles.endbox,'String'));
handles.clip=str2double(get(handles.clip_val_edit,'String'));


if handles.map_switch=='OD'
    for N=startval:endval
        set(handles.status,'String',sprintf('Clipping Block %d Ocular Dominance Map',N));drawnow;
        s=eval(sprintf('handles.axes%d',N));
        clipped_display(s,FullOD(:,:,N),handles.clip);
        clipped_display(handles.currentaxes,FullOD(:,:,N),handles.clip);
        set(handles.popupmenu1,'Value',N);drawnow;
        clipped_display(handles.sumaxes,sum(FullOD(:,:,startval:N),3),handles.clip);
    end
else
    for N=startval:endval
        set(handles.status,'String',sprintf('Clipping Block %d Orientation Map',N));drawnow;
        s=eval(sprintf('handles.axes%d',N));
        clipped_display(s,FullOR(:,:,N),handles.clip);
        clipped_display(handles.currentaxes,FullOR(:,:,N),handles.clip);
        set(handles.popupmenu1,'Value',N);drawnow;
        clipped_display(handles.sumaxes,sum(FullOR(:,:,startval:N),3),handles.clip);
    end
end
for N=startval:endval
    s=eval(sprintf('handles.block%dtoggle',N));
    set(s,'Value',1);
end
set(handles.status,'String','Resetting Active Blocks');drawnow;
handles.block_state=ones(1,16);
handles.active_blocks=1:16;
set(handles.status,'String','Done!');

guidata(hObject, handles);
% hObject    handle to clip_display (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Mixed_Callback(hObject, eventdata, handles)
FullOD=evalin('base','FullOD');
FullOR=evalin('base','FullOR');
path=get(handles.path,'String');
expnum=str2double(get(handles.edit6,'String'));
handles.clip=str2double(get(handles.clip_val_edit,'String'));
if isdir(sprintf('%s/Mixed_Maps/',path))==0
    mkdir(sprintf('%s/Mixed_Maps/',path));
end
default_filename=sprintf('%s/Mixed_Maps/Exp%g-%s-clip%g.jpg',path,expnum,handles.map_switch,handles.clip);
[FileName,PathName,FilterIndex] = uiputfile('*.jpg','Save As',default_filename);
startval=str2double(get(handles.startbox,'String'));
endval=str2double(get(handles.endbox,'String'));
if handles.map_switch=='OD'
    tmpim=sum(FullOD(:,:,handles.active_blocks),3);
else
    tmpim=sum(FullOR(:,:,handles.active_blocks),3);
end
%1mm scale bar
tmpim(1000:1010,853:1010)=max(max(tmpim));

figure;clipped_display(gca,tmpim,handles.clip);truesize;title(FileName);drawnow;
saveas(gca,sprintf('%s%s',PathName,FileName'));
% hObject    handle to Save_Mixed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_all_blocks_Callback(hObject, eventdata, handles)
% hObject    handle to Save_all_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_single_blocks_Callback(hObject, eventdata, handles)
% hObject    handle to Save_single_blocks (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Frame_top_Callback(hObject, eventdata, handles)
% hObject    handle to Save_Frame_top (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_single_frames_Callback(hObject, eventdata, handles)
% hObject    handle to Save_single_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_single_frame_Callback(hObject, eventdata, handles)
% hObject    handle to Save_single_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_all_frames_Callback(hObject, eventdata, handles)
% hObject    handle to Save_all_frames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


