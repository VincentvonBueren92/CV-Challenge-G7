%% Computer Vision Challenge 2020 challenge.m
% Call the function config.m
config;
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
  right_frame = squeeze(right(:,:, 1,:)); 
  left_frame = squeeze(left(:,:,1,:)); 

  % Render new frame
    new_frame = render(left_frame, mask, bg, mode);
end

%% Stop timer here
elapsed_time = 0;
elapased_time = toc(tStart);

% Init loop with 0
loop = 0

% Define Instance of imageReader
ImgReaderObj = ImageReader(src, L, R, start, N);
%% Write Movie to Disk
if store
    v = VideoWriter(dst,'Motion JPEG AVI');
    open(v);

    while loop ~= 1
      % Get next image tensors
      [left, right, loop] = ImgReaderObj.next();

      % Generate binary mask
      mask = segmentation(left, right);

      % Get the left and right frame as 3D Tensor (n_x, n_y, 3)
      left_frame = squeeze(left(:,:,1,:)); 

      % Render new frame
        new_frame = render(left_frame, mask, bg, mode);
        writeVideo(v,new_frame);
    end
end

close(v);
