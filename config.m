%% Computer Vision Challenge 2020 settings.m

%% Generall Settings
% Group number:
group_number = 7;

% Group members:
members = {'Amna', 'Hannes', 'Johannes', 'Andreas', 'Vincent'};

% Email-Address (from Moodle!):
mail = {'', '', '', 'ga94toq@tum.de', 'ga92cot@mytum.de'};


%% Setup Image Reader
% Specify Scene Folder
src = "/Users/amna.najib/Documents/amna/CV/data/P1E_S1";

% Select Cameras
L = 1
R = 2

% Choose a start point
start = 200

% Choose the number of succseeding frames
N = 100

% ir = ImageReader(src, L, R, start, N);


%% Output Settings
% Output Path
dst = "output.avi";

% Load Virual Background
bg = "/Users/amna.najib/Documents/amna/CV/data/background.jpeg"

% Select rendering mode
mode = "substitute";

% Create a movie array
% movie =

% Store Output?
store = true;

save('instance.mat', 'N', 'start', 'L', 'R', 'src', 'mode', 'store', 'bg', 'dst');
