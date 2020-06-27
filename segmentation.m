function [mask] = segmentation(left,right)
  % Add function description here
  %
  %

 
  
%% get gray Images
    s=size(left);

    for i = 1:s(2)
        gray_image{i} = rgb2gray(left{i});
    end
    
    
%% get Image difference of the last 3 frames (r,g,b seperatly)

    %% Tried to change color intensity for better results. But no success. 
    %s=size(left);
    %for i=1:s(2)
    %    %left_1{i}=imadjust(left{i},[0 0 0; 0.4 0.4 0.4],[]);
    %    left_1{i}=imadjust(left{i},[0.1 0.2 0.3; 0.7 0.8 0.9],[]);
         %left{i}=rgb2hsv(left{i})
    %end
    
    
    
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
    
    
    %% Use average of n images for a second recognition 
    s = size(left);
    Iaverage =zeros(size(left{1}));
    for i = 1:s(2)
        Iaverage = double(Iaverage) + double(left{i})/s(2);
    end
    
    im_diff = abs(uint8(Iaverage)-uint8(left{2}));
    im_diff = rgb2gray(im_diff);
    
    im_diff_bin = imbinarize(im_diff);
    imshow(im_diff_bin)
    
    
    %% Combine the average and the "binar" method
    im_bin=im_diff_bin | im_bin;
    im_bin = imgaussfilt(double(im_bin),5); % use gaussian filter for blurring the points
    im_bin = imbinarize(im_bin, 0.01); % make a binary picture again
    
%% Detect noise and set that points to 0
    im_bin = bwmorph(im_bin, 'majority', 5);
%% fill difference map
    %TODO: this process is currently a quite random sequence of functions
    %to fill out the difference map -> find more deterministic way

    %BW = bwmorph(im_bin,'bridge'); %try too conect components
    %BW = bwmorph(BW,'thicken',1); % thicken components
    
    %se = strel('square', 5); % Structuring element for dilation
    %BW = imdilate(im_bin, se); % Dilating the image
    
    %subplot(3,3,7)
    %imshow(im_bin)
    %se = strel('square', 5); % Structuring element for dilation
    %BW = imdilate(BW, se); % Dilating the image
    
    %BW = imfill(BW,'holes');
    %im_bin = BW;
    %se = strel('line', 4, 90); % Structuring element for dilation
    %BW = imdilate(BW, se); % Dilating the image
    %se = strel('line', 4, 0); % Structuring element for dilation
    %BW = imdilate(BW, se); % Dilating the image
    
    %BW = imfill(BW,'holes');
    %BW_difference = BW;
  
    
%% get intensity gradiant
    edges = edge(gray_image{2}, 'Canny');
    %TODO: idea(Hannes & Vincent) %smooth gradient by applying gussian
    %filter
    

    
%% AND - Connection between  difference map and gradient edges
    %AND = BW_difference & edges;
    AND = im_bin & edges;
    
    
    AND = bwareaopen(AND, 5); % removes small objects
    mask = AND;
    
    % use gaussian filter for blurring the points
    mask = imgaussfilt(double(mask),1)*100; 
    mask = imgaussfilt(double(mask),1);
    mask = imbinarize(mask)
   
    
%% fill MASK  
    %TODO: this process is currently a quite random sequence of functions
    %to fill out the difference map -> find more deterministic way
    %se = strel('square', 5); % Structuring element for dilation
    %mask1 = imdilate(AND, se); % Dilating the image
    
    %se = strel('square', 5); % Structuring element for dilation
    %mask1 = imdilate(mask1, se); % Dilating the image
    %mask2 = imfill(mask1,'holes');
    
    
    % only take the biggest 5 component
    %mask = bwareafilt(mask2, 5, 'Largest');
    %size(mask)

    %size(mask)
    % TODO find alternative for more than one person
    
    % mask = imbinarize(mask, 0.1);
    % fills hols
    mask = imfill(mask,'holes');
    % takes only the largest 
    mask = bwareafilt(mask, 5, 'Largest');
    
    
% plot steps in between
    figure(1);
    subplot(3,3,1);
    imshow(im_bin);
    subplot(3,3,2);
 %   imshow(BW_difference);
    subplot(3,3,3);
   % imshow(mask1);
    subplot(3,3,4);
    imshow(AND);
    subplot(3,3,5);
   % imshow(mask2);
    subplot(3,3,6);
    imshow(mask);
    subplot(3,3,7);
    imshow(edges)
    subplot(3,3,8)
    imshow(left{3}(:,:,3))
    
 
end
