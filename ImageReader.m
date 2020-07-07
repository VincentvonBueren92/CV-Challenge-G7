
% Image reader class
% 
% Computer Vision challenge 2020 (Group 7)
%
% Input:  (str)  src       Path to the scene (e.g. '/Users/hannes/ChokePoint_Dataset/P1E_S1')          No default value 
%         (int)  L         Chosen camera for the left frame (Valid: 1 or 2)                            Default: 1
%         (int)  R         Chosen camera for the left frame (Valid: 2 or 3)                            Default: 2
%         (int)  start     Start frame in the scene                                                    Default: 0
%         (int)  N         Get the the current frame + N further frames back (N+1 frames in total)     Default: 0
% 
% Output: (int)  left      Tensor with the images of the left camera. Dimensions: 600 × 800 × (N + 1) × 3 
%         (int)  right     Tensor with the images of the left camera. Dimensions: 600 × 800 × (N + 1) × 3
%         (bool) loop      FALSE if there are still enough images to return a full tensor.
%                          TRUE  if the user tries to grab more imagines than left in the scene_folder. Jump back to start value in the next call of next()

classdef ImageReader < handle
    
    properties
        src = '';       % Path to the scene (e.g., '/Users/hannes/ChokePoint_Dataset/P1E_S1'
        L = 1;          % Chosen camera for the left frame (Valid: 1 or 2)
        R = 2;          % Chosen camera for the left frame (Valid: 2 or 3)
        start = 0;      % Start frame in the scene
        N = 0;          % Get the the current frame + N further frames back (N+1 frames in total)
    end
    
    methods
        % Constructor
        function ir = ImageReader(src, L, R, varargin)
      
            % Input parser
            
            % Default values
            start_df = 0;
            N_df = 0;

            % Requirements
            src_val = @(x) exist(src, 'dir') == 7;
            L_val = @(x) isnumeric(x) && (ismember(x, [1, 2]));
            R_val = @(x) isnumeric(x) && (ismember(x, [2, 3]));
            start_val = @(x) isnumeric(x) && (x >= 0);
            N_val = @(x) isnumeric(x) && (x >= 0);

            % Matlab parser function
            p = inputParser;
            
            % Check requirements
            addRequired(p, 'src', src_val);
            addRequired(p, 'L', L_val);
            addRequired(p, 'R', R_val);
            addOptional(p, 'start', start_df, start_val);
            addOptional(p, 'N', N_df, N_val);

            parse(p, src, L, R, varargin{:});
            
            ir.src = p.Results.src;
            ir.L = p.Results.L;
            ir.R = p.Results.R;
            ir.start = p.Results.start;
            ir.N = p.Results.N;
        end
        
        function [left, right, loop] = next(this)
            
            % Persistent second loop variable. Will be updated to the actual 'loop' variable in the end
            persistent l;
            
            % Init l
            if isempty(l)
                l = 0;
            end           
            
            % Get scene folder name (e.g. 'P1E_S1') from the splitted up src path
            path_splits = regexp(this.src, filesep, 'split');
            scene_folder = char(path_splits(end)); 
            
            % Left/Right camera folder inside the scene folder
            cam_l_folder  = [scene_folder, '_C', num2str(this.L)];
            cam_r_folder  = [scene_folder, '_C', num2str(this.R)];
            
            % Path of scene folder + left/right camera folder
            scene_cam_l_path = fullfile(this.src, cam_l_folder);
            scene_cam_r_path = fullfile(this.src, cam_r_folder);
            
            % Image names of left/right camera
            img_list_l = dir(fullfile(scene_cam_l_path,'*.jpg'));
            img_list_r = dir(fullfile(scene_cam_r_path,'*.jpg'));
            
%             if ismac
%                 img_list_l = dir([scene_cam_l_path '/*.jpg']);      % Image names
%                 img_list_r = dir([scene_cam_l_path '/*.jpg']);
%                 % Code to run on Mac platform
%             elseif ispc
%                 disp("ad");
%                 img_list_l = dir([scene_cam_l_path '\*.jpg']) ;         % Image names
%                 img_list_r = dir([scene_cam_l_path '\*.jpg']);
%               
%                 % Code to run on Windows platform
%             else
%                 disp('Platform not supported')
%             end
             
            
            % Tensors with the images of the left/right camera. Dimensions: 600 × 800 × (N + 1) × 3
            left = [];
            right = [];
            
            % Calculation of the start and end value of the loop in which the images will be read
            loop_start = 1 + this.start;
            loop_end = 1 + this.start + this.N;
            img_num = length(img_list_l);
            
            % Start at the beginning of the image folder if the loop variable was set to 1 in the last call
            if l == 1
                loop_start = 1;
                loop_end = loop_start + this.N;
                l = 0;
            end
            
            % Check if there are not enough images left
            if loop_end >= img_num
                loop_end = img_num;
                l = 1;
                disp('End of scene_folder reached. Jumping back to the set start value in the next function call');
            end
           
            % Read images
            for k = loop_start : loop_end
                % Create full path of the current left/right image 
                img_name_l = fullfile(scene_cam_l_path, img_list_l(k).name);             
                img_name_r = fullfile(scene_cam_r_path, img_list_r(k).name);
                
                % Read left/right image from path
                img_l = imread(img_name_l);                                   
                img_r = imread(img_name_r);
                
                % Change dimensions of the images (600 × 800 × 3) to (600 × 800 × 1 × 3)
                img_l = reshape(img_l, size(img_l,1), size(img_l,2), 1, 3);   
                img_r = reshape(img_r, size(img_r,1), size(img_l,2), 1, 3);
                
                % Add the latest images to the two tensors (600 × 800 × (N + 1) × 3)
                left = cat(3, left, img_l);                  
                right = cat(3, right, img_r);
            end
            
            % Update the loop variable
            loop = l;

        end
        
    end

end