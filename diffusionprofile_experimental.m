%% Code for computing concentration profiles

clear all; close all; clc;

matrix_mean_pixel_intensity = []; % creates a null matrix for future data storage and to allow concatenation.

n = 16; % number of images to be analyzed

for jj = 1:1:n
  eval(['image_input = imread(''C:\Users\user\Desktop\thesis\Spatial Mixing\time lapse\' num2str(jj) '.tif'');']) % loads sequence of images

  if jj> 1 && jj<=n
    load matrix_mean_pixel_intensity; % loads mean_pixel_intensity.mat
  end

  imshow(image_input); % displays the input image
  gray_image = rgb2gray(image_input); % converts RGB image to grayscale
  
  figure(2); % creates a separate figure
  cropped_gray_image = imcrop(gray_image, [700 0 1400 1920]); % automatically crops the image according to [x y width height]
  imshow(cropped_gray_image); % displays the cropped up image
  [rows columns extraneous]= size(cropped_gray_image); % extracta information regarding number of pixels in the cropped image
  line_divisions = double(cropped_gray_image(1:rows,1:columns)); % converts the type of 'cropped_grayscale_image' to double
  
  mean_pixel_intensity = zeros(rows,1); % initializes a vector for storage of mean pixel intensity
  min_I = mean(min(line_divisions)); % finds minimum value of intensity in the image
  max_I = mean(max(line_divisions)); % finds maximum value of intensity in the image
  del_I = max_I - min_I; % difference between the maximum and the minimum intensities
  
  if del_I ~= 0 % executes command for incomplete mixing
    line_divisions(1:rows,:) = 255*(line_divisions(1:rows,:)- min_I)./(del_I); % scales or stretches the pixel intensity on 0-255 scale
    for i = 1:rows
    mean_pixel_intensity(i,1) = mean(line_divisions(i,:)); % computes the mean pixel intensity
    end
  elseif del_I == 0 % executes command for zero diffusion-gradient
    mean_pixel_intensity(:,1) = max_I; % set constant intensity for all pixels
  end

  matrix_mean_pixel_intensity = [matrix_mean_pixel_intensity, mean_pixel_intensity]; % concatenates mean pixel intensity of multiple images for multiple execution
  save matrix_mean_pixel_intensity 'matrix_mean_pixel_intensity'; % saves the vector 'matrix_mean_pixel_intensity'
  pause(0.1) % adds delay of 0.1 sec
end

%% Plotting results from previous cell
clear all; close all; clc;

load matrix_mean_pixel_intensity; % loads 'matrix_mean_pixel_intensity'
S = size(matrix_mean_pixel_intensity); % records size of matrix_mean_pixel_intensity
normalized_width = (1:1:S(1))'/S(1); % generates normalized width using number of rows of pixels
plot(normalized_width,matrix_mean_pixel_intensity) % generates a plot of pixel intensity along the width
