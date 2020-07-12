%% Computer Vision Challenge 2020 challenge.m

% Call the function config.m
config;
% Import ImageReader
import ImageReader.*;

%% Start timer here
tStart =  tic;

% Define Instance of imageReader
ImgReaderObj = ImageReader(src, L, R, start, N);

%% Generate Movie
% Init loop variable
loop = 0;

while loop ~= 1
	% Get next image tensors
    [left, loop, ~] = ImgReaderObj.next_left();
    ImgReaderObj.start = ImgReaderObj.start +1;
      
    % Generate binary mask
    right = left;
    mask = segmentation(left, right);

    % Get the left 3D tensor
    left_frame = squeeze(left(:,:,2,:)); 

    % Render new frame
    movie = cat(4, movie,render(left_frame, mask, bg, mode)) ;
end

%% Stop timer here
elapsed_time = 0;
elapsed_time = toc(tStart);

disp("The running time(s) of rendering is: "); disp(elapsed_time)

%% Start time for saving the video
tStart =  tic;
%% Write Movie to Disk
if store
    [~, ~, ~, N] = size(movie)
    % Create a video Instance
    v = VideoWriter(dest,'Motion JPEG AVI');
    % Set the fps to 30
    v.FrameRate = 30;
    % Open the video
    open(v);

    % Loop over movie to save the movie
    for i=1:N
        new_frame = squeeze(movie(:,:,:,i));
        writeVideo(v,new_frame);
    end
    % Close the video after saving
    close(v);

end

%% Stop time (for saving the video)

tEnd = toc(tStart);
disp("The running time(s) of saving the video is: "); disp(tEnd)
