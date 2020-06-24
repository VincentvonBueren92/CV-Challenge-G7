%% Computer Vision Challenge 2020 settings.m

%% Generall Settings
% Group number:
% group_number = 0;

% Group members:
% members = {'Max Mustermann', 'Johannes Daten'};

% Email-Address (from Moodle!):
% mail = {'ga99abc@tum.de', 'daten.hannes@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
src = "Path/to/my/ChokePoint/P1E_S1";

% Select Cameras
% L =
% R =

% Choose a start point
% start = randi(1000)

% Choose the number of succseeding frames
% N =

ir = ImageReader(src, L, R, start, N);


%% Output Settings
% Output Path
dst = "output.avi";

% Load Virual Background
% bg = imread("Path\to\my\virtual\background")

% Select rendering mode
mode = "substitute";

% Create a movie array
% movie =

% Store Output?
store = true;
