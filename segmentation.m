function [mask] = segmentation(left,right)
    %% This function is used to segment moving elements. 
    %For this purpose N elements are passed as RGB tensors in the input 
    % variable "left". The function calculates an average image from the
    % N elements, from which the average image (round(N/2)) of the N
    % transferred images is subtracted. In a further step the resulting 
    % difference image, which is still an RGB image, is converted into a 
    % gray image. From this gray image a binary image is created in a 
    % further step. This binary image, which is partly still noisy, is 
    % then converted into a noise-free binary image using several filters.
    % Gaussian filters ensure a better filling of the images. The Gaussian
    % filters result in a mask with too large outcuts.  To reduce this mask 
    % a negative image is created. A Gaussian filter is applied to 
    % the created nagitve image, which enlarges the mask of the nagitve 
    % image. Since the negative mask is now enlarged, a new negation of 
    % the negative mask will result in a binary image which is smaller 
    % than the original mask. 


 %% Get number of handed over images and remove one dimentional tensor
 
    size_left = size(left);
    
  for i=1:size_left(3)
      left_tensor{i} = squeeze(left(:,:,i,:));
      right_tensor{i} = squeeze(right(:,:,i,:));
  end
    
    %% Crate a binary mask out of difference images  
    %Initialize average tensor with zeros
    Iaverage_RGB_Tensor =zeros(size(left_tensor{1}));
    % Create average tensor
    for i = 1:size_left(3)
        Iaverage_RGB_Tensor = double(Iaverage_RGB_Tensor) + double(left_tensor{i})/size_left(3);
    end
    % get number of the middle image 
    middle_Image_number = int8(size_left(3)/2);
    % substract the middle tensor from the average Tensor and geht the abs
    im_diff_RGB_tensor = abs(uint8(Iaverage_RGB_Tensor)-uint8(left_tensor{middle_Image_number}));
    % convert RGB-Tensor to 
    im_diff_grey = rgb2gray(im_diff_RGB_tensor);
    % create binary out of the grey image
    im_diff_bin = imbinarize(im_diff_grey,0.01);
    % get rid of black pixel within white areas
    im_diff_bin = imfill(im_diff_bin,'holes');
    % choose only binary areas that are bigger than 50 pixels
    im_diff_bin = bwareaopen(im_diff_bin, 50);
    

    %% Get a filled binary mask out of the difference images
    % usa a Gaussian to blurry the difference images binary mask
    im_diff_bin_filled = imgaussfilt(double(im_diff_bin),40)*10;
    
    % try to fill holes
    im_diff_bin_filled = imfill(im_diff_bin_filled,"holes");
    
    % binarize the now blurried image with filled holes 
    im_diff_bin_filled = imbinarize(im_diff_bin_filled, 0.1);
    
    %% create a negative image
    % creat a negative binary picture out of the binary picture
    % initialize a binary image for a negative image
    im_bin_neg = ones(size(im_diff_bin_filled));
    % crate neagitve image
    im_bin_neg = im_bin_neg - im_diff_bin_filled;
    
    % Use Gauß on negative binary picture to blurry the negative picture 
    % what results in a bigger margin
    im_bin_neg = imgaussfilt(double(im_bin_neg),25)*10;
    % binarize the blurried nagative image with a set threshold value
    im_bin_neg = imbinarize(im_bin_neg,0.01);
    %% create a smaller mask out of nagative image
    % initialize a image with ones for a new mask and subtract the created
    % negative binary image with the bigger margin
    % by the reversal we now obtain a reduced mask outcut
    im_bin_neg= ones(size(im_bin_neg))-im_bin_neg;
    % binarize the image again
    mask = imbinarize(im_bin_neg,0.1);
 
end
