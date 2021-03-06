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

% Initializes the save container for videos
global saved_Video;

% Initializes State Struct which holds user video configurations
global states;
states = struct('gui_loop_set', 0, 'gui_start', 0,'be_src', 0, 'be_L',1,'be_R', 2, 'be_N', 2, 'EXIT', 0, 'selected_bg', 0, 'selected_mode', 'background', 'gui_save', 0, 'standby_mode', 0, 'max_num_frames', 100000);

% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

message = {'Hi there!', ' ', 'This is just a quick info for you!', ' ',  'First, you have to browse a scene with the Browse button.', ' ', 'Second you can choose the start value, mode and also your preferred background image (JPG).', ' ', 'Now, you can start the videos with the START button... with the PAUSE and PLAY button, you can manipulate the playing.', ' ', 'With the LOOP button, you can choose to play the videos in an infinite loop.', ' ', 'Finally, with the RECORD button, you can record and then save the rendered video.', ' ', 'ENJOY :)' };

% Info window when opening GUI
h=msgbox(message, 'Introduction','help');
  

% ************************ Choose Mode ************************************
% --- Executes on selection change in choose_mode.
function choose_mode_Callback(hObject, eventdata, handles)
% hObject    handle to choose_mode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns choose_mode contents as cell array
%        contents{get(hObject,'Value')} returns selected item from choose_mode
global states;

% Gets the selected mode 
contents = cellstr(get(hObject,'String'));
selected_mode = contents{get(hObject,'Value')};

% Checks for wrong input possibilities
var = '-----------';
var1 = 'Choose a Mode';
if strcmp(var,selected_mode)
    return
elseif strcmp(var1,selected_mode)
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
global states;
global saved_Video;

% Checks for record and stop record condition
if(strcmp(get(handles.save_btn,'String'),'RECORD'))
    
    % Sets the state variable for saving to 1 so that new frames can be
    % added
    states.gui_save = 1;
    
    % Defines output name for later saving
    dest = "output.avi";
    
    % Initializes Videowriter object
    saved_Video = VideoWriter(dest,'Motion JPEG AVI');
    
    % Changes video object to 30fps
    saved_Video.FrameRate = 30; %set to 30 frames per second
    
    % Opens object for writing
    open(saved_Video);
    
    % Change of naming of button
    set(handles.save_btn,'String','STOP RECORD');
else
    % Change of naming of button
    set(handles.save_btn,'String','RECORD');
    
    % Sets the state variable back to zero to signal end of recording
    states.gui_save = 0;
    
    % Closes video object
    close(saved_Video);
end


% ************************ Loop the Video**********************************
function loop_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global states;

% Sets and unsets the loop condition for the frame replay
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
global saved_Video

% If the user chooses a start_number which is bigger than the max number of
% frames in scene, the counter will start at 0
if states.gui_start > states.max_num_frames-3
    counter = 0;
else
    % Set the counter to chosen gui_start value (default is zero)
    counter = states.gui_start;
end
    
% Resets the standbye mode to zero for replay of scenes
states.standby_mode = 0;

while(1 && ~states.EXIT && ~states.standby_mode)
    
    % Creates an ImageReader object with current counter value and chosen
    % configurations
    imageReadObject = ImageReader(states.be_src, states.be_L, states.be_R, counter, states.be_N);
    [left, loop, img_num] = imageReadObject.next_left();
    
    % Fake unused right tensor 
    right = left;
    
    % Segmentation of the images and creation of mask
    mask = segmentation(left, right);
    
    % Returns selected mode & background
    mode = states.selected_mode;
    bg = states.selected_bg;
    
    % Saves the max number of max_num_frames
    states.max_num_frames = img_num;

    % Checks if the substitute mode is chosen, but a background image is
    % missing
    if (bg == 0) & strcmp(mode,'substitute')
     
        % Message box for background selection
        message = {'Oh noooo!!!', ' ', 'You forgot to choose a background image!', ' ',  'Remember, it has to be a JPG file'};
        h=msgbox(message, 'Choose a background image');
        
        % Requests for background selection
        browse_bg_Callback();
        
        bg = states.selected_bg;
        
        % Checks for operating systems and extracts the filename of image
        if ispc
            splitted_path_arr = strsplit(bg,'\');
            set(handles.bg_presented, 'String', splitted_path_arr(end));
        else
            splitted_path_arr = strsplit(bg,'/');
            set(handles.bg_presented, 'String', splitted_path_arr(end));
        end
        
    % Checks if substitute mode is chosen (the bg image is defined)
    elseif strcmp(mode,'substitute')
        
        bg = states.selected_bg;
        
        % Checks for operating systems and extracts the filename of image
        if ispc
            splitted_path_arr = strsplit(bg,'\');
            set(handles.bg_presented, 'String', splitted_path_arr(end));
        else
            splitted_path_arr = strsplit(bg,'/');
            set(handles.bg_presented, 'String', splitted_path_arr(end));
        end
    end
    
    % Gets the frame of the left camera and of the right camera
    frame_left = squeeze(left(:,:,2,:));
    
    % Renders the frame of the left camera given the mode and bg
    rendered_frame = render(frame_left, mask, bg, mode);
    
    % Checks if the user want to save a file and adds to new frames to
    % video object
    if states.gui_save
        writeVideo(saved_Video,rendered_frame);
    end
    
    % Delete figure stack to increase performance
    cla reset;
    
    % Show images for left and right camera
    imagesc(rendered_frame, 'Parent', handles.axes1);
    imagesc(frame_left, 'Parent', handles.axes2);
    
    % Remove axes
    axis(handles.axes1,'off');
    axis(handles.axes2,'off');

    % Update the shown frame counter
    frame_text1 = strcat(' / ', num2str(img_num-3));
    frame_text2 = strcat(num2str(counter), frame_text1);
    set(handles.frame_num, 'String', frame_text2);
    
    % Present the chosen mode
    set(handles.mode_presented, 'String', mode);
        
    drawnow;
    
    % Increment the frame counter
    counter = counter + 1;
    
    % Checks for the flag (loop:= end of video)
    if loop == 1
        % If GUI is manually set to loop, reset counter to selected start
        % value
        if states.gui_loop_set == 1
            counter = states.gui_start;
        else
            %The video has finished and we exit the loop
            states.standby_mode = 1;
        end
    end 
end


% ************************ BROWSE *****************************************
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

% User pressed cancel in the src selection
if ~ischar(states.be_src )
  disp('User pressed Cancel');
  return;  % Or what ever is applicable
end

% Instatiates ImageReader object
imageReadObject = ImageReader(states.be_src, states.be_L, states.be_R, counter, states.be_N);

% get the first three images of camera left and right
[left, loop, img_num] = imageReadObject.next_left();

% Saves the max number of max_num_frames
states.max_num_frames = img_num;

% Prepare frames
first_frame_left = squeeze(left(:,:,1,:));

% Load first images in figures
imagesc(first_frame_left,'Parent', handles.axes1);
imagesc(first_frame_left,'Parent', handles.axes2);
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
  
 % ************************ Choose Start Number ***************************
function choose_start_Callback(hObject, eventdata, handles)
% hObject    handle to choose_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of choose_start as text
%        str2double(get(hObject,'String')) returns contents of choose_start as a double

% Update the start value
global states;

% Represents the selected value for start
chosen_num = str2num(get(hObject,'String'));
states.gui_start = chosen_num;

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


% ************************ Pause the Video ********************************
function pause_btn_Callback(hObject, eventdata, handles)
% hObject    handle to pause_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Stops the execution of the videos
uiwait();
