function varargout = DIGEGUI(varargin)
% DIGEGUI M-file for DIGEGUI.fig
%      DIGEGUI, by itself, creates a new DIGEGUI or raises the existing
%      singleton*.
%
%      H = DIGEGUI returns the handle to a new DIGEGUI or the handle to
%      the existing singleton*.
%
%      DIGEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DIGEGUI.M with the given input arguments.
%
%      DIGEGUI('Property','Value',...) creates a new DIGEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DIGEGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DIGEGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DIGEGUI

% Last Modified by GUIDE v2.5 27-Mar-2008 12:07:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DIGEGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @DIGEGUI_OutputFcn, ...
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


% --- Executes just before DIGEGUI is made visible.
function DIGEGUI_OpeningFcn(hObject, eventdata, handles, varargin)
[file,path]=uigetfile('*.dvi','Select the Cy3 Image','~/Desktop');
Cy3im=medfilt2(log(DVI_read(sprintf('%s%s',path,file))));
axes(handles.axes1);
imagesc(Cy3im);
assignin('base','Cy3im',Cy3im);

[file,path]=uigetfile('*.dvi','Select the Cy5 Image',sprintf('%s',path));
Cy5im=medfilt2(log(DVI_read(sprintf('%s%s',path,file))));
axes(handles.axes2);
imagesc(Cy5im);
assignin('base','Cy5im',Cy5im);



% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DIGEGUI (see VARARGIN)

% Choose default command line output for DIGEGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DIGEGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DIGEGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in ChangeIm.
function ChangeIm_Callback(hObject, eventdata, handles)
[file,path]=uigetfile('*.dvi','Select the Cy3 Image','~/Desktop');
Cy3im=medfilt2(log(DVI_read(sprintf('%s%s',path,file))));
axes(handles.axes1);
imagesc(Cy3im);
assignin('base','Cy3im',Cy3im);

[file,path]=uigetfile('*.dvi','Select the Cy5 Image',sprintf('%s',path));
Cy5im=medfilt2(log(DVI_read(sprintf('%s%s',path,file))));
axes(handles.axes2);
imagesc(Cy5im);
assignin('base','Cy5im',Cy5im);

% hObject    handle to ChangeIm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Run.
function Run_Callback(hObject, eventdata, handles)
Cy3im=double(evalin('base','Cy3im'));
Cy5im=double(evalin('base','Cy5im'));
ratiocutoff=1.5;
% this is the meat of what the GUI does
panel_size=[256 256];
numxpanels=4;
numypanels=5;
Cy3panelstack=zeros(panel_size(1),panel_size(2),numxpanels*numypanels);
Cy5panelstack=zeros(panel_size(1),panel_size(2),numxpanels*numypanels);
panelcount=0;
set(handles.outputtxt,'String','Flattening Images');
drawnow;
for xpanel=0:numxpanels-1
    for ypanel=0:numypanels-1
        panelcount=panelcount+1;
        Cy3panel=Cy3im(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1));
        Cy5panel=Cy5im(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1));
        images=cjfDIGEPanel(Cy3panel,Cy5panel);
        Cy3panelstack(:,:,panelcount)=images.FlatCy3im;
        Cy5panelstack(:,:,panelcount)=images.FlatCy5im;
    end
end

%% Recompile the flattened images
set(handles.outputtxt,'String','Recompiling Flattened Images...');
drawnow;
FlatCy3=zeros(size(Cy3im));
FlatCy5=zeros(size(Cy5im));
panelcount=0;
for xpanel=0:numxpanels-1
    for ypanel=0:numypanels-1
        panelcount=panelcount+1;
        FlatCy3(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1))=Cy3panelstack(:,:,panelcount);
        FlatCy5(panel_size(2)*ypanel+1:panel_size(2)*ypanel+panel_size(2),panel_size(1)*xpanel+1:panel_size(1)*xpanel+panel_size(1))=Cy5panelstack(:,:,panelcount);
    end
end
finalimages.FlatCy3=FlatCy3;
finalimages.FlatCy5=FlatCy5;

%% Ask the User to Crop the image
set(handles.outputtxt,'String','Choose ROI');
imagesc(FlatCy5);
drawnow;
[finalimages.FlatCy5,croprect]=imcrop;
finalimages.FlatCy5=double(finalimages.FlatCy5);
imagesc(FlatCy3);
drawnow;
finalimages.FlatCy3=imcrop(finalimages.FlatCy3,croprect);
finalimages.Cy3orig=imcrop(Cy3im,croprect);
finalimages.Cy5orig=imcrop(Cy5im,croprect);
%% Find Spot edges in the flattened Cy3 image and define spot domains based on
%% the edges.

%%%%%%%%%%%%%%%%%%%%%%%%%   Version 2.0 code   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%set(handles.outputtxt,'String','Calculating Spot Domains...');
%drawnow;
%totalim3=zeros(size(finalimages.FlatCy3));
%totalim5=zeros(size(finalimages.FlatCy3));
%for N=5:15
%    se=strel('disk',N);
%    tmpim=imregionalmax(imopen(finalimages.FlatCy3,se));
%    totalim3=tmpim+totalim3;
%    axes(handles.axes1);imagesc(totalim3);drawnow;
%end
%for N=5:15
%    se=strel('disk',N);
%    tmpim=imregionalmax(imopen(finalimages.FlatCy5,se));
%   totalim5=tmpim+totalim5;
%    axes(handles.axes2);imagesc(totalim5);drawnow;
%end
%mask3=totalim3>5;
%mask5=totalim5>5;
%finalimages.Edges=(mask3+mask5)>0;
%finalimages.EdgesOverlay3=~finalimages.Edges.*finalimages.Cy3orig;
%finalimages.EdgesOverlay5=~finalimages.Edges.*finalimages.Cy5orig;
%finalimages.EdgeDistance=bwdist(finalimages.Edges);
%finalimages.SpotDomains=bwlabel(finalimages.Edges);
%%%%%%%%%%%%%%%%%%%%%%%%%   Version 2.0 code   %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%   Version 1.0 code   %%%%%%%%%%%%%%%%%%%%%%%%%%%
%set(handles.outputtxt,'String','Calculating Spot Domains...');
%drawnow;
%se=strel('disk',5);
%eroded=imerode(finalimages.FlatCy5,se);
%finalimages.Opened=imreconstruct(eroded,finalimages.FlatCy5);
%opened3=imopen(finalimages.FlatCy3,se);
%opened5=imopen(finalimages.FlatCy5,se);
%finalimages.Edges=(imregionalmax(opened3)+imregionalmax(opened5))>0;
%finalimages.EdgesOverlay3=~finalimages.Edges.*finalimages.Cy3orig;
%finalimages.EdgesOverlay5=~finalimages.Edges.*finalimages.Cy5orig;
%finalimages.Edges=edge(finalimages.FlatCy3,'canny');
%finalimages.EdgeDistance=bwdist(finalimages.Edges);
%finalimages.SpotDomains=watershed(finalimages.EdgeDistance);
%finalimages.SpotDomains=bwlabel(finalimages.Edges);
%%%%%%%%%%%%%%%%%%%%%%%%%   Version 1.0 code   %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%   Version 3.0 code   %%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.outputtxt,'String','Calculating Cy3 Spot Domains...');
drawnow;
[Cy3i,Cy3j,Cy3p]=cjf_blob_main(finalimages.FlatCy3);
set(handles.outputtxt,'String','Calculating Cy5 Spot Domains...');
drawnow;
[Cy5i,Cy5j,Cy5p]=cjf_blob_main(finalimages.FlatCy5);
i=horzcat(Cy3i,Cy5i);
j=horzcat(Cy3j,Cy5j);
p=Cy3p+Cy5p;
finalimages.Edges=zeros(size(finalimages.FlatCy3));
for N=1:p
    finalimages.Edges(i(N),j(N))=1;
end
finalimages.EdgesOverlay3=~finalimages.Edges.*finalimages.Cy3orig;
finalimages.EdgesOverlay5=~finalimages.Edges.*finalimages.Cy5orig;

finalimages.EdgeDistance=bwdist(finalimages.Edges);

se=strel('disk',5);
finalimages.SpotDomains=imdilate(finalimages.Edges>0,se);
%finalimages.SpotDomains=watershed(finalimages.EdgeDistance);
finalimages.SpotDomains=bwlabel(finalimages.SpotDomains);
%%%%%%%%%%%%%%%%%%%%%%%%%   Version 3.0 code   %%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Calculate the mean and standard deviation of the mean ratio from all
%% spot domains.
set(handles.outputtxt,'String','Finding Significantly Different Spots...');
drawnow;
summary.Ratios=[];
summary.Diffs=[];
for N=2:max(max(finalimages.SpotDomains));
    found=finalimages.SpotDomains==N;
    Cy3mean=mean2(finalimages.FlatCy3(found));
    Cy5mean=mean2(finalimages.FlatCy5(found));
    summary.Ratios=horzcat(summary.Ratios,Cy3mean/Cy5mean);
    summary.Diffs=horzcat(summary.Diffs,Cy3mean-Cy5mean);
end
summary.RatioMean=mean(summary.Ratios);
summary.RatioStd=std(summary.Ratios);
summary.DiffMean=mean(summary.Diffs);
summary.DiffStd=std(summary.Diffs);

%% Find spots that are significantly different from the mean ratio
summary.RatioSigSpots=find(summary.Ratios>summary.RatioMean+ratiocutoff*summary.RatioStd | summary.Ratios<summary.RatioMean-ratiocutoff*summary.RatioStd);
summary.DiffSigSpots=find(summary.Diffs>summary.DiffMean+ratiocutoff*summary.DiffStd | summary.Diffs<summary.DiffMean-ratiocutoff*summary.DiffStd);




summary.RatioFoundSpots=length(summary.Ratios);
summary.RatioNumSig=length(summary.RatioSigSpots);
summary.DiffFoundSpots=length(summary.Diffs);
summary.DiffNumSig=length(summary.DiffSigSpots);

summary


outputstring{1}=sprintf('Found %d ratio spots, %d of which were significant at %d times the standard deviation about the ratio mean'...
    ,length(summary.Ratios),length(summary.RatioSigSpots),ratiocutoff);
outputstring{2}=sprintf('Found %d difference spots, %d of which were significant at %d times the standard deviation about the difference mean'...
    ,length(summary.Diffs),length(summary.DiffSigSpots),ratiocutoff);
set(handles.outputtxt,'String',outputstring);
assignin('base','summary',summary);
assignin('base','images',finalimages);

% hObject    handle to Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Spot.
function Spot_Callback(hObject, eventdata, handles)
DIGESpotViewerGUI;
% hObject    handle to Spot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
images=evalin('base','images');
axes(handles.axes1);
val = get(handles.popupmenu1,'Value');
switch val
    case 1
        imagesc(images.FlatCy3);
    case 2
        imagesc(images.Edges);
    case 3
        imagesc(images.EdgeDistance);
    case 4
        imagesc(images.Cy3orig.*~(images.SpotDomains==0));;
    case 5
        imagesc(images.Cy3orig);
    case 6
        imagesc(images.EdgesOverlay3);
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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
images=evalin('base','images');
axes(handles.axes2);
val = get(handles.popupmenu2,'Value');
switch val
    case 1
        imagesc(images.FlatCy5);
    case 2
        imagesc(images.Edges);
    case 3
        imagesc(images.EdgeDistance);
    case 4
        imagesc(images.Cy5orig.*~(images.SpotDomains==0));
    case 5
        imagesc(images.Cy5orig);
    case 6
        imagesc(images.EdgesOverlay5);
end
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


% --- Executes on button press in Histogram.
function Histogram_Callback(hObject, eventdata, handles)
summary=evalin('base','summary');
images=evalin('base','images');
figure;
imagesc(images.Cy5orig);truesize;colormap(gray);axis off;
for N=1:length(summary.RatioSigSpots)
    [ylist,xlist]=find(images.SpotDomains==summary.RatioSigSpots(N));
    if summary.RatioSigSpots(N)>summary.RatioMean
        text(max(xlist),max(ylist),sprintf('R%d',N),'Color',[1 0 0]);
        rectangle('EdgeColor','r','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);drawnow;
    else
        text(max(xlist),max(ylist),sprintf('R%d',N),'Color',[0 1 0]);
        rectangle('EdgeColor','g','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);drawnow;
    end
end
figure;
imagesc(images.Cy5orig);truesize;colormap(gray);axis off;
for N=1:length(summary.DiffSigSpots)
    [ylist,xlist]=find(images.SpotDomains==summary.DiffSigSpots(N));
    if summary.DiffSigSpots(N)>summary.DiffMean
        text(max(xlist),max(ylist),sprintf('D%d',N),'Color',[1 0 0]);
        rectangle('EdgeColor','r','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);drawnow;
    else
        text(max(xlist),max(ylist),sprintf('D%d',N),'Color',[0 1 0]);
        rectangle('EdgeColor','g','Position',[min(xlist) min(ylist) max(xlist)-min(xlist) max(ylist)-min(ylist)]);drawnow;
    end
end
% hObject    handle to Histogram (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Proc.
function Proc_Callback(hObject, eventdata, handles)
% hObject    handle to Proc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Quit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Quit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Man_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Man_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function new_menu_Callback(hObject, eventdata, handles)
% hObject    handle to new_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function outputtxt_Callback(hObject, eventdata, handles)
% hObject    handle to outputtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputtxt as text
%        str2double(get(hObject,'String')) returns contents of outputtxt as a double


% --- Executes during object creation, after setting all properties.
function outputtxt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputtxt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


