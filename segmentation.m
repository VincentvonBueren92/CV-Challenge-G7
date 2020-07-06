function [mask] = segmentation(left,right)
  % Add function description here
  %
  %

 size_left = size(left);
 
  for i=1:size_left(3)

      left_tensor{i} = squeeze(left(:,:,i,:));
      right_tensor{i} = squeeze(right(:,:,i,:));
  end
  
%% get gray Images


    for i = 1:size_left(3)
        gray_image{i} = rgb2gray(left_tensor{i});
    end
    
    
%% get Image difference of the last 3 frames (r,g,b seperatly)

    %% Tried to change color intensity for better results. But no success. 
    %s=size(left);
    %for i=1:s(2)
    %    %left_1{i}=imadjust(left{i},[0 0 0; 0.4 0.4 0.4],[]);
    %    left_1{i}=imadjust(left{i},[0.1 0.2 0.3; 0.7 0.8 0.9],[]);
         %left{i}=rgb2hsv(left{i})
    %end
    
    
    
    im_diff_r{1} = left_tensor{1}(:,:,1)-left_tensor{2}(:,:,1);
    im_bin_r{1} = imbinarize(im_diff_r{1});

    im_diff_g{1} = left_tensor{1}(:,:,2)-left_tensor{2}(:,:,2);
    im_bin_g{1} = imbinarize(im_diff_g{1});

    im_diff_b{1} = left_tensor{1}(:,:,3)-left_tensor{2}(:,:,3);
    im_bin_b{1} = imbinarize(im_diff_b{1});
   
    im_diff_r{2} = left_tensor{2}(:,:,1)-left_tensor{3}(:,:,1);
    im_bin_r{2} = imbinarize(im_diff_r{2});

    im_diff_g{2} = left_tensor{2}(:,:,2)-left_tensor{3}(:,:,2);
    im_bin_g{2} = imbinarize(im_diff_g{2});

    im_diff_b{2} = left_tensor{2}(:,:,3)-left_tensor{3}(:,:,3);
    im_bin_b{2} = imbinarize(im_diff_b{2});

    % compose all detected difference
    im_bin_1 = im_bin_r{1} & im_bin_g{1} &im_bin_b{1};
    im_bin_2 = im_bin_r{2} & im_bin_g{2} &im_bin_b{2};
    
    im_bin_or = im_bin_1 & im_bin_2;
    se = strel('disk',10);
    im_bin_or = imclose(im_bin_or, se);
    im_bin_or = bwareaopen(im_bin_or, 2000);
    
    
    %% Use average of n images for a second recognition 
    Iaverage =zeros(size(left_tensor{1}));
    for i = 1:size_left(3)
        Iaverage = double(Iaverage) + double(left_tensor{i})/size_left(3);
    end
    middle = int8(size_left(3)/2);
    im_diff = abs(uint8(Iaverage)-uint8(left_tensor{middle}));
    im_diff = rgb2gray(im_diff);
    
    im_diff_bin = imbinarize(im_diff,0.01);
    se = strel('disk',10);
    im_bin_or = imclose(im_bin_or, se);
    im_diff_bin = bwareaopen(im_diff_bin, 50);
    
    
    %% Combine the average and the "binar" method wird nicht mehr kombiniert
    im_bin_combined=im_diff_bin; %| im_bin_or;
    %% Use Gauß in im_bin
    im_diff_bin_filled = imgaussfilt(double(im_bin_combined),40)*10;
    
    % try to fill holes
    im_diff_bin_filled = imfill(im_diff_bin_filled,"holes");
    im_diff_bin_filled = imbinarize(im_diff_bin_filled, 0.1);
    
    %im_bin = imgaussfilt(double(im_bin_combined),10); % use gaussian filter for blurring the points
    %im_bin = imbinarize(im_bin, 0.01); % make a binary picture again
    
    % creat a negative binary picture out of the binary picture
    im_bin_neg = ones(size(im_diff_bin_filled));
    im_bin_neg = im_bin_neg - im_diff_bin_filled;
    
    % Use Gauß on negative binary picture to smaller cutout
    im_bin_neg = imgaussfilt(double(im_bin_neg),25)*10;
    im_bin_neg = imbinarize(im_bin_neg,0.01);
    im_bin_neg= ones(size(im_bin_neg))-im_bin_neg;
    im_bin_neg = imbinarize(im_bin_neg,0.1);
    im_bin = im_bin_neg;
    
 
%% Detect noise and set that points to 0
    %im_bin = bwmorph(im_bin, 'majority', 5);
    

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
    %edges = edge(gray_image{2}, 'Canny');
    %im_edges_bin = edges&im_bin_combined;
    %im_edges_bin = imgaussfilt(double(im_edges_bin),10);
    %im_edges_bin = imbinarize(im_edges_bin,0.01);
    %TODO: idea(Hannes & Vincent) %smooth gradient by applying gussian
    %filter
    

    
%% AND - Connection between  difference map and gradient edges
    %AND = BW_difference & edges;
    %AND = im_bin & edges;
    
    
    %AND = bwareaopen(AND, 5); % removes small objects
    %mask = AND;
    
    % use gaussian filter for blurring the points
    %mask = imgaussfilt(double(mask),1)*100; 
    %mask = imgaussfilt(double(mask),1);
    %mask = imbinarize(mask);
    %mask_boundary = bwboundaries(mask);
    %mask_2 = regionprops(mask, 'Centroid', 'BoundingBox');
    %mask = im_bin;
    
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
    mask = im_bin;
    mask = imfill(mask,'holes');
    % takes only the largest 
    mask = bwareafilt(mask, 7, 'Largest');
    
% % plot steps in between
%     figure(1);
%     subplot(3,3,1);
%     imshow(im_diff_bin);
%     
%     subplot(3,3,2);
%     imshow(im_bin_combined);
%     subplot(3,3,3);
%     imshow(im_diff_bin_filled);
%     subplot(3,3,4);
%     imshow(im_bin_neg);
%     subplot(3,3,5);
%     imshow(im_bin_neg);
%     subplot(3,3,6);
%     imshow(mask);
%     subplot(3,3,7);
%     %imshow(im_diff_bin)
%     subplot(3,3,8)
%     %imshow(left{3}(:,:,3))
%     subplot(3,3,9)
% %    imshow(im_edges_bin);
    
 
end
