function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 02-Jul-2020 18:43:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

set(handles.stop_btn,'Enable','off');
set(handles.start_btn,'Enable','off');
set(handles.loop_btn,'Enable','off');
set(handles.save_btn,'Enable','off');


% Loop variable is set
global loop_set;
loop_set = 0;




% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in choose_bg.
function choose_bg_Callback(hObject, eventdata, handles)
% hObject    handle to choose_bg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_bg contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_bg
src_path = strcat(pwd, '/src');
FileList = dir(fullfile(src_path, '*.jpg*'));
NameList = {FileList.name};
PathList = fullfile({FileList.folder}, NameList);
set(handles.choose_bg, 'String', NameList);  % Or Name list, as you want
contents = cellstr(get(hObject,'String'))
disp(contents{get(hObject,'Value')})

% --- Executes during object creation, after setting all properties.
function choose_bg_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_bg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in chose_mode.
function chose_mode_Callback(hObject, eventdata, handles)
% hObject    handle to chose_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chose_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chose_mode
src_path = strcat(pwd, '/src');
FileList = dir(fullfile(src_path, '*.mp4*'));
NameList = {FileList.name};
PathList = fullfile({FileList.folder}, NameList);
set(handles.chose_mode, 'String', NameList);  % Or Name list, as you want
contents = cellstr(get(hObject,'String'))
disp(contents{get(hObject,'Value')})


% --- Executes during object creation, after setting all properties.
function chose_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chose_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function select_start_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function select_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stop_btn.
function stop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to stop_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(strcmp(get(handles.stop_btn,'String'),'STOP'))
    set(handles.stop_btn,'String','PLAY');
    uiwait();
else
    set(handles.stop_btn,'String','STOP');
    uiresume();
end
    



% --- Executes on button press in save_btn.
function save_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(hObject,'Value') == 1
    disp('The SAVE button is set');
else
    disp('The SAVE button is NOT set');
end

% --- Executes on button press in save_btn.
function loop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global loop_set;

if(strcmp(get(handles.loop_btn,'String'),'LOOP'))
    disp("Compared works")
    set(handles.loop_btn,'String','NO LOOP');
    loop_set = 1;
else
    set(handles.loop_btn,'String','LOOP');
    loop_set = 0;
end


% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_btn
% hObject    handle to play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stores 0 using the name, 'userdata'.
set(handles.stop_btn, 'userdata', 0);

global loop_set;

% Retrieves video source
videoObject = handles.videoObject;
set(handles.stop_btn,'Enable','on');
set(handles.start_btn,'Enable','off');
axes(handles.axes1);

frameCount = 2;
while frameCount <= videoObject.NumberOfFrames
    
    set(handles.frame_num1,'String',num2str(frameCount));
    frame = read(videoObject,frameCount);
    imshow(frame);
    drawnow();
    frameCount = frameCount + 1;
    
    if (frameCount == videoObject.NumberOfFrames && loop_set)
        frameCount = 2;
    end
end 

% ************************ BROWSE TEXT BOX ********************************
function scene_field_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function scene_field_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% ************************ BROWSE *****************************************
% --- Executes on button press in pushbutton1.
function browse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[ video_file_name,video_file_path ] = uigetfile({'*.mp4'},'Pick a video file');      %;*.png;*.yuv;*.bmp;*.tif'},'Pick a file');
if(video_file_path == 0)
    return;
end
input_video_file = [video_file_path,video_file_name];
disp(video_file_name)
set(handles.scene_field,'String',video_file_name);
% Acquiring video
videoObject = VideoReader('./src/flight.mp4');
% Display first frame
frame_1 = read(videoObject,1);
axes(handles.axes1);
imshow(frame_1);
drawnow;
axis(handles.axes1,'off');
% Display Frame Number
set(handles.frame_num1,'String',['  /  ',num2str(videoObject.NumFrames)]);
set(handles.start_btn,'Enable','on');
set(handles.loop_btn,'Enable','on');
set(handles.stop_btn,'Enable','off');
%Update handles
handles.videoObject = videoObject;
guidata(hObject,handles);


function frame = getAndProcessFrame(videoSrc)
% Read input video frame
frame = step(videoSrc);


% --- Executes on button press in exit_btn.
function exit_btn_Callback(hObject, eventdata, handles)
% hObject    handle to exit_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close all;
input=menu('Are you sure that you want to quit the simulation?',...
    'YES','NO');
  switch input
      case 1
          closereq;
      case 2
          return
  end

function choose_start_Callback(hObject, eventdata, handles)
% hObject    handle to choose_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of choose_start as text
%        str2double(get(hObject,'String')) returns contents of choose_start as a double


% --- Executes during object creation, after setting all properties.
function choose_start_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
