% Code for calculating relative mixing index for a mixing event from a sequence of images

clear all; close all; clc;

matrix_rel_mixing_index = []; % creates a null matrix for future data storage and to allow concatenation.

n =19; % number of images to be analyzed

for jj = 1:1:n
  while jj ~= 1
  load matrix_rel_mixing_index; % loads matrix_rel_mixing_index.mat
  break
  end

  eval(['image_input = imread(''D:\research\thesis\mixing index\correct images\nikon\bright\' num2str(jj) '.tif'');']) % loads images from destination folder
  % image_input(:,:,4) = [];
  imshow(image_input); % displays the input image
  gray_image = rgb2gray(image_input); % converts RGB image to grayscale
  figure(2); % creates a separate figure
  cropped_gray_image = imcrop(gray_image,[654.5 83.5 (698-654) (867-83)]); % automatically crops the image according to [x y width height]
  imshow(cropped_gray_image); % displays the cropped up image
  [rows columns extraneous]= size(cropped_gray_image); % extracts information regarding number of pixels in the cropped image
  line_divisions = double(cropped_gray_image(1:rows,1:columns)); % converts the type of 'cropped_grayscale_image' to double
  mean_I = mean(line_divisions(:,:)); % computes mean pixel intensities in the selected area
  while jj ==1
    for j = 1:columns
      standard_deviation_not(1,j) = (sum((line_divisions(:,j)-((mean_I(1,j)))).^2))^0.5;
    end
  standard_deviation_not = mean(standard_deviation_not); % computes original std. deviation
  break
  end

  for j =1:columns
    standard_deviation(1,j) = (sum((line_divisions(:,j)-(mean_I(1,j))).^2))^0.5;
  end
  standard_deviation = mean(standard_deviation); % computes local std. deviation
  avg_relative_mixing_index = (1- standard_deviation/standard_deviation_not)*100; % yields relative mixing index from std. deviation
  matrix_rel_mixing_index = [matrix_rel_mixing_index, avg_relative_mixing_index]; % concatenates mixing indices of multiple images for multiple execution
  save matrix_rel_mixing_index 'matrix_rel_mixing_index' 'standard_deviation_not' 'n'; % saves the vector 'matrix_mixing_index' and scalar ' n '
  pause(0.05)
end

%% Plotting and curve-fitting relative mixing indices
close all; clear all; close all

time = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 150, 180, 210, 240, 270, 300, 330, 360]; % time elapsed at which images were captured
load matrix_rel_mixing_index; % loads 'matrix_rel_mixing_index'
time = time(1:n);
curve_fit = polyval(polyfit(time,matrix_rel_mixing_index,4),time); % fits a polynomial through the data
plot(time,matrix_rel_mixing_index,'rs',time, curve_fit,'linewidth',2) % plots experimental data and curve fits it
xlabel('Time elapsed (sec)'); ylabel('(1 - Relative Mixing Index)*100%');
