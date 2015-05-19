% Code for plotting histogram for pixel intensity at various flow-rates

clear all; close all; clc;

n = 3; % initializing a scalar representing the images to be analyzed
jj = 1; % initializing the counter
figure; % creates a figure

while jj <= n
  eval(['image_input = imread(''C:\Users\user\Desktop\thesis\Spatial Mixing\spatial mixing\matlab\' num2str(jj) '.tif'');']) % inputs ...
  % sequence of images in Matlab
  gray_image = rgb2gray(image_input); % converts RGB image to grayscale
  cropped_gray_image = imcrop(gray_image,[700 0 1400 1920]); % automatically crops the image according to [x y width height]
  imhist(cropped_gray_image); % plots the histogram of pixel intensity
  hold on % holds the figure
  jj = jj+1; % raises the counter
  pause(0.1) % adds a delay
end
