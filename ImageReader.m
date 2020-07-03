classdef ImageReader
  % Add class description here
  %
  %
    properties
        src = '';
        L = 0;
        R = 0;
        start = 0;
        N = 0;
    end
    
    methods
        % Constructor
        function ir = ImageReader(src, L, R, varargin)
      
            % Input parser
            
            % Standart values
            src_df = '/Users/hannes/ChokePoint_Dataset/P1E_S1';
            L_df = 1;
            R_df = 2;
            start_df = 0;
            N_df = 1;

            % Requirements
            src_val = @(x) exist(src, 'dir') == 7;  % Check if file path exists
            L_val = @(x) isnumeric(x) && (x >= 1) && (x <= 2);
            R_val = @(x) isnumeric(x) && (x >= 2) && (x <= 3);
            start_val = @(x) isnumeric(x) && (x >= 0);
            N_val = @(x) isnumeric(x) && (x >= 1);

            % Matlab parser function
            p = inputParser;
            addRequired(p, 'src');
            addRequired(p, 'L');
            addRequired(p, 'R');
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
            
            % persistent loop variable
            persistent l;
            
            % Init l
            if isempty(l)
                l = 0;
            end           
            
            path_splits = regexp(this.src, filesep, 'split');
            folder = char(path_splits(end));    % Scene folder
            
            left_folder = [folder, '_C', num2str(this.L)];    % Camera folder inside scene folder
            right_folder = [folder, '_C', num2str(this.R)];
            
            left_path = fullfile(this.src, left_folder);       % Path of scene folder + specific camera folder
            right_path = fullfile(this.src, right_folder);
            
            left_image_names = dir([left_path '/*.jpg']);          % Image names
            right_image_names = dir([left_path '/*.jpg']);
            
            % Tensors with the images
            left = [];
            right = [];
            
            loop_start = 1 + this.start;
            loop_end = 1 + this.start + this.N;
            img_num = length(left_image_names);
            
            % Start at the beginning of the function if the loop variable was set to 1 in the last call
            if l == 1
                loop_start = 1;
                loop_end = loop_start + this.N;
            end
            
            % Set loop variable if there are not enough images
            if loop_end >= img_num
                loop_end = img_num;
                l = 1;
            end
           
            % Read images
            for k = loop_start : loop_end
                left_name = fullfile(left_path, left_image_names(k).name);  % Full path of an image                
                left_img = imread(left_name);
                left_img = reshape(left_img, size(left_img,1), size(left_img,2), 1, 3);   % Change dimensions
                left = cat(3, left, left_img);                  % Create tensor with mutiple images (600 × 800 × (N + 1) · 3)
                
                right_name = fullfile(right_path, right_image_names(k).name);  % Full path of an image
                right_img = imread(right_name);
                right_img = reshape(right_img, size(right_img,1), size(left_img,2), 1, 3);
                right = cat(3, right, right_img);
            end
            
            % figure;
            % image(left(:,:,1,1));
            size(left); 
            
            loop = l;

        end
        
    end

end