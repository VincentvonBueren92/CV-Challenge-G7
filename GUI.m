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

% Last Modified by GUIDE v2.5 06-Jul-2020 23:55:32

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


% Import ImageReader class
import ImageReader.*;


% Global variables which define flow of GUI (be:= backend, gui:=
% graphical user interfac)
global gui_loop_set;
global be_src;
global be_L;
global be_R;
global gui_start;
global be_N;
global EXIT;

% Initialize the global variables
gui_loop_set = 0;
gui_start = 0;
be_L = 1;
be_R = 2;
be_N = 2;
EXIT = 0;




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

% Define source path
src_path = strcat(pwd, '/src');

% Extract only jpg background files
FileList = dir(fullfile(src_path, '*.jpg*'));
NameList = {FileList.name};

PathList = fullfile({FileList.folder}, NameList);
set(handles.choose_bg, 'String', NameList); 

% Extracts the name
contents = cellstr(get(hObject,'String'));

disp(contents{get(hObject,'Value')});

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


% --- Executes on selection change in choose_mode.
function choose_mode_Callback(hObject, eventdata, handles)
% hObject    handle to choose_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_mode
disp(contents{get(hObject,'Value')})


% --- Executes during object creation, after setting all properties.
function choose_mode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to choose_mode (see GCBO)
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


% --- Executes on button press in save_btn.
function loop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global gui_loop_set;

if(strcmp(get(handles.loop_btn,'String'),'LOOP'))
    disp("Compared works")
    set(handles.loop_btn,'String','NO LOOP');
    gui_loop_set = 1;
else
    set(handles.loop_btn,'String','LOOP');
    gui_loop_set = 0;
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

% Initialize all the global variables
global gui_loop_set;
global gui_start;
global be_L;
global be_R;
global be_src;
global be_N;
global EXIT;

% Set the counter to chosen gui_start value (default is zero)
counter = gui_start;

while(1 && ~EXIT)
    
    imageReadObject = ImageReader(be_src, be_L, be_R, counter, be_N)
    [left, right, loop] = imageReadObject.next();
    
    % Segmentation of the images and creation of mask
    mask = segmentation(left, right);
    
    % Returns selected item from choose background
    %bg = contents{get(handles.choose_bg,'Value')};
    bg = 'src/office.jpg'; % Just for Debugging
    
    % Returns selected item from choose background
    %mode = contents{get(handles.choose_mode,'Value')};
    mode = 'substitute'; % Just for Debugging
    
    % Gets the frame of the left camera and of the right camera
    frame_left = squeeze(left(:,:,1,:));
    frame_right = squeeze(right(:,:,1,:));
    
    % Renders the frame of the left camera given the mode and bg
    rendered_frame = render(frame_left, mask, bg, mode);
    
    % Delete figure stack to increase performance
    cla reset;
    
    % Show images for left and right camera
    imagesc(rendered_frame, 'Parent', handles.axes1);
    imagesc(frame_right, 'Parent', handles.axes2);
    
    % Remove axes
    axis(handles.axes1,'off');
    axis(handles.axes2,'off');
    drawnow;
    
    % Increment the frame counter
    counter = counter + 1;
    
    % Checks for the flag (loop:= end of video)
    if loop == 1
        % If GUI is manually set to LOOP, reset counter to choose_start
        if gui_loop_set == 1
            counter = gui_start;
        else
            %The video has finished and we exit the loop
            break
        end
    end 
end

% Clears all axes
close all;

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

% Choose scene from src directories
global be_src;
global be_L;
global be_R;
global be_N;
global gui_start

be_src = uigetdir();    

set(handles.choose_start,'Enable','on');
set(handles.start_btn,'Enable','on');
set(handles.save_btn,'Enable','on');
set(handles.stop_btn,'Enable','on');
set(handles.loop_btn,'Enable','on');

counter = gui_start;
imageReadObject = ImageReader(be_src, be_L, be_R, counter, be_N);
[left, right, loop] = imageReadObject.next();
first_frame_left = squeeze(left(:,:,1,:));
first_frame_right = squeeze(right(:,:,1,:));

imagesc(first_frame_left,'Parent', handles.axes1);
imagesc(first_frame_right,'Parent', handles.axes2);
drawnow;
axis(handles.axes1,'off');
axis(handles.axes2,'off');

disp(be_src); % FOR DEBUGGING


function frame = getAndProcessFrame(videoSrc)
% Read input video frame
frame = step(videoSrc);


% --- Executes on button press in exit_btn.
function exit_btn_Callback(hObject, eventdata, handles)
% hObject    handle to exit_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close all;
global EXIT;

input=menu('Are you sure that you want to quit the simulation?',...
    'YES','NO');
  switch input
      case 1
          EXIT = 1;
          closereq;
          close all
      case 2
          return
  end

function choose_start_Callback(hObject, eventdata, handles)
% hObject    handle to choose_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of choose_start as text
%        str2double(get(hObject,'String')) returns contents of choose_start as a double

% Update the global variabel start
global gui_start;
gui_start = str2num(get(hObject,'String'));




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


% TODO
% - CREATE A MSG BOX WITH, INSTRUCTIONS...CHOOSE START NUMBER
% - YOU CAN ONLY CHOOSE VALID SOURCE FOLDERS
% - REALLY IMPORTANT IN CURRENT IMAGEREADER CLASS THE LOOP VALUE HAS TO BE
% SET BACK TO ZERO
%     


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
global EXIT;
EXIT = 1;
delete(hObject);

function uipanel2_DeleteFcn(hObject, eventdata, handles)
