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

% Last Modified by GUIDE v2.5 07-Jul-2020 23:26:43

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

% Import ImageReader class
import ImageReader.*;


% Initiates State Struct
global states;
states = struct('gui_loop_set', 0, 'gui_start', 0,'be_src', 0, 'be_L',1,'be_R', 2, 'be_N', 2, 'EXIT', 0, 'selected_bg', './src/office.jpg', 'selected_mode', 'substitute');

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% ************************ Choose Mode ************************************
% --- Executes on selection change in choose_mode.
function choose_mode_Callback(hObject, eventdata, handles)
% hObject    handle to choose_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_mode
global states;
contents = cellstr(get(hObject,'String'));
selected_mode = contents{get(hObject,'Value')};

var = '-----------';
if strcmp(var,selected_mode)
    return
else
    states.selected_mode = selected_mode;
end
    




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


% ************************ Choose Start Number ****************************
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


% ************************ Stop and Play **********************************
function play_btn_Callback(hObject, eventdata, handles)
% hObject    handle to play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Resumes the play of the videos
uiresume();

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
global states;

if(strcmp(get(handles.loop_btn,'String'),'LOOP'))
    disp("Compared works")
    set(handles.loop_btn,'String','NO LOOP');
    states.gui_loop_set = 1;
else
    set(handles.loop_btn,'String','LOOP');
    states.gui_loop_set = 0;
end

% ************************ START *****************************************
% --- Executes on button press in start_btn.
function start_btn_Callback(hObject, eventdata, handles)
% hObject    handle to start_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of start_btn
% hObject    handle to play_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global states

% Set the counter to chosen gui_start value (default is zero)
counter = states.gui_start;

while(1 && ~states.EXIT)
    
    imageReadObject = ImageReader(states.be_src, states.be_L, states.be_R, counter, states.be_N);
    [left, right, loop, img_num] = imageReadObject.next();
    
    % Segmentation of the images and creation of mask
    mask = segmentation(left, right);
    
    % Returns selected item from choose background
    bg = states.selected_bg;
    
    % Returns selected mode
    mode = states.selected_mode;
    
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

    % Update the shown frame counter
    frame_text1 = strcat(' / ', num2str(img_num));
    frame_text2 = strcat(num2str(counter), frame_text1);
    set(handles.frame_num, 'String', frame_text2);
    
    % Present the chosen mode and background
    set(handles.mode_presented, 'String', mode);
    
    % Checks for operating systems and extracts the filename of image
    if ispc
        splitted_path_arr = strsplit(bg,'\');
        set(handles.bg_presented, 'String', splitted_path_arr(-1));
    else
        splitted_path_arr = strsplit(bg,'/');
        set(handles.bg_presented, 'String', splitted_path_arr(end));
    end
        
    drawnow;
    % Increment the frame counter
    counter = counter + 1;
    
    % Checks for the flag (loop:= end of video)
    if loop == 1
        % If GUI is manually set to LOOP, reset counter to selected start
        % value
        if states.gui_loop_set == 1
            counter = states.gui_start;
        else
            %The video has finished and we exit the loop
            break
        end
    end 
end

% Clears all axes
close all;

% ************************ BROWSE *****************************************
% --- Executes on button press in pushbutton1.
function browse_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initializes state vector
global states;

% Saves the files origi in be_src
states.be_src = uigetdir();    

% Assigns counter to selected start value
counter = states.gui_start;

% Instatiates ImageReader object
imageReadObject = ImageReader(states.be_src, states.be_L, states.be_R, counter, states.be_N);

% get the first three images of camera left and right
[left, right, loop, img_num] = imageReadObject.next();

% Prepare frames
first_frame_left = squeeze(left(:,:,1,:));
first_frame_right = squeeze(right(:,:,1,:));

% Load first images in figures
imagesc(first_frame_left,'Parent', handles.axes1);
imagesc(first_frame_right,'Parent', handles.axes2);
drawnow;

% Remove axes in figures
axis(handles.axes1,'off');
axis(handles.axes2,'off');


% ************************ Exit** *****************************************
function exit_btn_Callback(hObject, eventdata, handles)
% hObject    handle to exit_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%close all;
global states;

% Menu for Exit confirmation
input=menu('Are you sure that you want to quit the simulation?',...
    'YES','NO');
  switch input
      % Exit is approved, clear all figures and exit GUI
      case 1
          states.EXIT = 1;
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

% Update the start value
global states;
states.gui_start = str2num(get(hObject,'String'));

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

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Closes all the figures when figures get closed
global states;
states.EXIT = 1;
delete(hObject);

function uipanel2_DeleteFcn(hObject, eventdata, handles)


% ************************ Choose Background ******************************
function browse_bg_Callback(hObject, eventdata, handles)
% hObject    handle to browse_bg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Initializes state vector
global states;

% Gets the path and the file of the background selected
[bg_name, path_name] = uigetfile('*.jpg', 'Select an image file:');
if ~ischar(bg_name)
  disp('User pressed Cancel');
  return;  % Or what ever is applicable
end

% Complete path to file
bg_image_path = fullfile(path_name, bg_name);

% Updates bg_presented
states.selected_bg = bg_image_path;


% --- Executes on button press in pause_btn.
function pause_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pause_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stops the execution of the videos
uiwait();




% TODO
% - CREATE A MSG BOX WITH, INSTRUCTIONS...CHOOSE START NUMBER
% - YOU CAN ONLY CHOOSE VALID SOURCE FOLDERS
% - REALLY IMPORTANT IN CURRENT IMAGEREADER CLASS THE LOOP VALUE HAS TO BE
% SET BACK TO ZERO
%     
