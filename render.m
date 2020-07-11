function [result] = render(frame,mask,bg,render_mode)
  % Add function description here
  %
  %
  switch render_mode
      case 'foreground'
          % mask original frame
          result(:,:,1) = frame(:,:,1).*uint8(mask);
          result(:,:,2) = frame(:,:,2).*uint8(mask);
          result(:,:,3) = frame(:,:,3).*uint8(mask);
     
      case 'background'
        %get background mask
        mask_complement = imcomplement(mask);
        
        %mask original frame
        result(:,:,1) = frame(:,:,1).*uint8(mask_complement);
        result(:,:,2) = frame(:,:,2).*uint8(mask_complement);
        result(:,:,3) = frame(:,:,3).*uint8(mask_complement);
      
      case 'overlay'
        % get background mask
        mask_complement = imcomplement(mask);

        % get green Image
        fg_green = zeros(size(frame));
        % green foreground
        fg_green(:,:,2) = 255*uint8(mask);
        
        % get red Image
        bg_red = zeros(size(frame));
        % red background
        bg_red(:,:,1) = 255*uint8(mask_complement);

        % combine red and green
        overlay(:,:,1) = fg_green(:,:,1)+bg_red(:,:,1);
        overlay(:,:,2) = fg_green(:,:,2)+bg_red(:,:,2);
        overlay(:,:,3) = fg_green(:,:,3)+bg_red(:,:,3);

        % make transparent overlay
        result(:,:,1) = uint8(overlay(:,:,1))*0.5+frame(:,:,1);
        result(:,:,2) = uint8(overlay(:,:,2))*0.5+frame(:,:,2);
        result(:,:,3) = uint8(overlay(:,:,3))*0.5+frame(:,:,3);
      
      case 'substitute'
          
        % scale background to frame size
        I = imread(bg); 
        scaled_bg = imresize(I,[size(frame,1) size(frame,2)]);
        
        % get background mask
        mask_complement = imcomplement(mask);

        % mask foreground
        masked_Im(:,:,1) = frame(:,:,1).*uint8(mask);
        masked_Im(:,:,2) = frame(:,:,2).*uint8(mask);
        masked_Im(:,:,3) = frame(:,:,3).*uint8(mask);

        % mask background
        comp_masked_bg(:,:,1) = scaled_bg(:,:,1).*uint8(mask_complement);
        comp_masked_bg(:,:,2) = scaled_bg(:,:,2).*uint8(mask_complement);
        comp_masked_bg(:,:,3) = scaled_bg(:,:,3).*uint8(mask_complement);

        % combine fore- and background
        result(:,:,1) = comp_masked_bg(:,:,1)+masked_Im(:,:,1);
        result(:,:,2) = comp_masked_bg(:,:,2)+masked_Im(:,:,2);
        result(:,:,3) = comp_masked_bg(:,:,3)+masked_Im(:,:,3);
      
      otherwise 
        disp('no valid render_mode')
  end
  

end
