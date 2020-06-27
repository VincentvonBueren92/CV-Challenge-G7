clear all;
clc;
close all;

bg = imread('virtual_background.jpg');

scene = 1;
start_pic=274;
end_pic=276;

if scene == 1
    for i = 1:end_pic-start_pic+1
        Im{i}=imread(['00000' int2str(i+start_pic-1) '.jpg']);
    end

    

elseif scene == 2
Im{1} = imread('00000279.jpg');
Im{2} = imread('00000280.jpg');
Im{3} = imread('00000281.jpg');
elseif scene == 3
Im{1} = imread('00004767.jpg');
Im{2} = imread('00004768.jpg');
Im{3} = imread('00004767.jpg');
elseif scene == 4
Im{1} = imread('00000139.jpg');
Im{2} = imread('00000140.jpg');
Im{3} = imread('00000141.jpg');
end


frame = Im{2}; 
left = Im;
right = [];


mask = segmentation(left,right);
f=size(frame)
result = render(frame,mask,bg,'foreground');

figure(2);
imshow(result);





