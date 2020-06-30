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
            src_df = '/Users/hannes/ChokePoint_Dataset';
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
        
        function [mask] = segmentation(left,right)
         
        end
        
    end

end
