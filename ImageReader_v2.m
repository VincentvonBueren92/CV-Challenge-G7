classdef ImageReader
  % Add class description here
  % Documentation on defining classes in Matlab: https://de.mathworks.com/help/matlab/matlab_oop/create-a-simple-class.html
  % Example on defining the constructer: https://de.mathworks.com/help/matlab/matlab_oop/class-constructor-methods.html#:~:text=A%20constructor%20method%20is%20a,an%20instance%20of%20the%20class.&text=All%20MATLAB%C2%AE%20classes%20have,that%20overrides%20the%20default%20constructor.
  % 
  
  % Add properties
  properties
      % mustBeMember user guide:
      % https://de.mathworks.com/help/matlab/ref/mustbemember.html (option as parser)
      src = ''; % Path of the sequence
      L = 1; % number of the left camera 
      R  = 2; % number of the right camera
      start = 0; % start point of the frames lecture
      N = 1; % How many frames to load using next method
  end
  
  methods 
      % Add the class constructor
      function obj = ImageReader(src, L, R, varargin)
          
          % Set default values
          defaultSource = '/Users/amna.najib/Documents/amna/CV/data/P1E_S1';
          defaultLeft = 1;
          defaultRight = 2;
          defaultStart = 0;
          defaultN = 1;
          
          % Add valid values 
          validSource = @(x) exist(src, 'dir') == 7;
          validLeft = @(x) isnumeric(x) && (ismember(x, [1, 2]));
          validRight = @(x) isnumeric(x) && (ismember(x, [2, 3]));
          validStart = @(x) isnumeric(x) && (x>=0);
          validN = @(x) isnumeric(x) && (x>=1);
          
          % Parser
          p = inputParser;
          addRequired(p, 'source', validSource);
          addRequired(p, 'left', validLeft);
          addRequired(p, 'right', validRight);
          addOptional(p, 'start', defaultStart, validStart);
          addOptional(p, 'N', defaultN, validN);
          
          parse(p, src, L, R, varargin{:});
          
          % Assign the variables
          obj.src = p.Results.source;
          obj.L = p.Results.left;
          obj.R = p.Results.right;
          obj.start = p.Results.start;
          obj.N = p.Results.N;
      end
        
        % Set the method next
        function loop = next(this)
            
            % Define the variable loop
            
            % Set loop variable l 
            persistent l; 
            % Set iterator variable it
            persistent it; 
            
            % Init l
            if isempty(l)
                l = 0;
            end
            
            % Init it
            if isempty(it)
                it = this.start + 1;
            end
            
            % Get folder name
            list_path = split(this.src, filesep) ;
            folder = char(list_path(end))
            
            % Set the cam1 & cam2 folders
            cam1_folder = [folder, '_C', num2str(this.L)]; 
            cam2_folder = [folder, '_C', num2str(this.R)];
            
            % Set the paths to left(cam1) and right(cam2) img sequences
            cam1_path = fullfile(this.src, cam1_folder);       
            cam2_path = fullfile(this.src, cam2_folder);

            % Reference for Reading imgs and getting the sequence of imgs:
            % https://de.mathworks.com/matlabcentral/answers/24461-reading-sequence-of-jpeg-images-from-current-directory
            left_imgs = dir(fullfile(cam1_path , '/*.jpg'));       
            right_imgs = dir(fullfile(cam2_path , '/*.jpg'));
            
            % Set the number of images in the folder
            num_imgs = length(left_imgs);
            
            % Init left & right
            left = [];
            right = [];
            
            % Set the beginning "it_start" and end of the loop "it_end"
            it_start = it
            it_end = it_start + this.N;
            
            % Change the end of the loop iterator if achieving the end of
            % the folder files
            if it_end > num_imgs
                it_end = num_imgs
                l = 1;
            end
            
            % Iterate over the sequence
            for i = it_start:it_end
                % Read the left image
                left_name = fullfile(cam1_path, left_imgs(i).name);              
                left_img = imread(left_name);   
                % Reshape the image to [n, m, 1, 3]: 3 for RGB
                left_img = reshape(left_img, size(left_img,1), size(left_img,2), 1, 3);   
                % Concatenate the left_img to the tensor left
                left = cat(3, left, left_img);  
                
                % Read right image
                right_name = fullfile(cam2_path, right_imgs(i).name); 
                right_img = imread(right_name);
                % Reshape the image to [n, m, 1, 3]: 3 for RGB
                right_img = reshape(right_img, size(right_img,1), size(left_img,2), 1, 3);
                % Concatenate the right_img to the tensor right
                right = cat(3, right, right_img);
                
                % Set loop variable + consider the case of reaching the end
                if l ~=1 & i==it_end
                    it = it_end +1
                    loop = l
                elseif l == 1 & i==it_end
                    it = 1
                    loop = l
                    l = 0
                    % l = 2
                    % loop = l-2
                end
            end

            % A truecolor (RGB) image sequence, specified as an M-by-N-by-3-by-K array.
            % Change the tensor to fit implay requirement
            left_vis = reshape(left, size(right_img,1), size(left_img,2), 3, []);
            % Play the sequence
            implay(left_vis);
        end
    end
end
