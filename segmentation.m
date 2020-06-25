function [mask] = segmentation(left,right)
  % Add function description here
  %
  %

%% get gray Images
  for i = 1:size(left)
        img_double = double(left{i});
        gray_image_double = img_double(:,:,1)*0.299 + img_double(:,:,2)*0.587 + img_double(:,:,3)*0.114;
        gray_image{i} = uint8(gray_image_double);
    end

%% get Image difference of the last 3 frames (r,g,b seperatly)
    im_diff_r{1} = left{1}(:,:,1)-left{2}(:,:,1);
    im_bin_r{1} = imbinarize(im_diff_r{1});

    im_diff_g{1} = left{1}(:,:,2)-left{2}(:,:,2);
    im_bin_g{1} = imbinarize(im_diff_g{1});

    im_diff_b{1} = left{1}(:,:,3)-left{2}(:,:,3);
    im_bin_b{1} = imbinarize(im_diff_b{1});
   
    im_diff_r{2} = left{2}(:,:,1)-left{3}(:,:,1);
    im_bin_r{2} = imbinarize(im_diff_r{2});

    im_diff_g{2} = left{2}(:,:,2)-left{3}(:,:,2);
    im_bin_g{2} = imbinarize(im_diff_g{2});

    im_diff_b{2} = left{2}(:,:,3)-left{3}(:,:,3);
    im_bin_b{2} = imbinarize(im_diff_b{2});

    % compose all detected difference
    im_bin_1 = im_bin_r{1} | im_bin_g{1} |im_bin_b{1};
    im_bin_2 = im_bin_r{2} | im_bin_g{2} |im_bin_b{2};

    im_bin = im_bin_1 | im_bin_2;
    
%% fill difference map
    %TODO: this process is currently a quite random sequence of functions
    %to fill out the difference map -> find more deterministic way

    BW = bwmorph(im_bin,'bridge'); %try too conect components
    BW = bwmorph(BW,'thicken',10); % thicken components
    
    se = strel('line', 5, 90); % Structuring element for dilation
    BW = imdilate(BW, se); % Dilating the image
    se = strel('line', 5, 0); % Structuring element for dilation
    BW = imdilate(BW, se); % Dilating the image
    
    BW = imfill(BW,'holes');
    
    se = strel('line', 4, 90); % Structuring element for dilation
    BW = imdilate(BW, se); % Dilating the image
    se = strel('line', 4, 0); % Structuring element for dilation
    BW = imdilate(BW, se); % Dilating the image
    
    BW = imfill(BW,'holes');

    BW_difference = BW;
%% get intensity gradiant
    edges = edge(gray_image{1},'Canny');
    %TODO: idea(Hannes & Vincent) smooth gradient by applying gussian
    %filter
    
%% AND - Connection between  difference map and gradient edges
    AND = BW_difference & edges;
    
    
%% fill MASK  
    %TODO: this process is currently a quite random sequence of functions
    %to fill out the difference map -> find more deterministic way
    se = strel('line', 3, 90); % Structuring element for dilation
    mask1 = imdilate(AND, se); % Dilating the image
    
    se = strel('line', 3, 0); % Structuring element for dilation
    mask1 = imdilate(mask1, se); % Dilating the image
    mask2 = imfill(mask1,'holes');

    %only take the biggest component
    mask = bwareafilt(mask2, 1, 'Largest');
    % TODO find alternative for more than one person

% plot steps in between
    figure(1);
    subplot(2,3,1);
    imshow(im_bin);
    subplot(2,3,2);
    imshow(BW_difference);
    subplot(2,3,3);
    imshow(AND);
    subplot(2,3,4);
    imshow(mask2);
    subplot(2,3,5);
    imshow(mask);

 
end
