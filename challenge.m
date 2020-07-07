%% Computer Vision Challenge 2020 challenge.m
% Import config file for restoring defined variables
load('instance.mat');

%% Write Movie to Disk
if store
  v = VideoWriter(dst,'Motion JPEG AVI');
  open(v);
end

%% Start timer here
tStart =  tic;

% Define Instance of imageReader
ImgReaderObj = ImageReader(src, L, R, start, N);

%% Generate Movie
% Init loop
loop = 0;
while loop ~= 1
  % Get next image tensors
  [left, right, loop] = ImgReaderObj.next();

  % Generate binary mask
  mask = segmentation(left, right);
  
  % Get the left and right frame as 3D Tensor (n_x, n_y, 3)
  % Only for testing with smaller number of frames, otherwise with loop
  right_frame = squeeze(right(:,:,1,:)); 
  left_frame = squeeze(left(:,:,1,:)); 
  
  % Render new frame
  new_frame = render(left_frame, mask, bg, mode);
  if store
      writeVideo(v,new_frame);
  end

end

%% Stop timer here
elapsed_time = 0;
tEnd = toc(tStart);

disp(tEnd);

close(v);