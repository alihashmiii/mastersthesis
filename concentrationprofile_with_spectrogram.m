%% Code for generating concentration profiles
clear all; close all; clc;

matrix_mean_pixel_intensity = []; % creates a null matrix for future data storage and to allow concatenation.
n = 619; % number of images to be analyzed

for jj = 1:1:n
  eval(['image_input = imread(''C:\Users\user\Desktop\videocompressed-fastchemicalswitch\frames-1Hz\' num2str(jj) '.jpeg'');']) % loads sequence of images
  if jj> 1 && jj<=n
    load matrix_mean_pixel_intensity; % loads mean_pixel_intensity.mat
  end
  
  imshow(image_input); % displays the input image
  gray_image = rgb2gray(image_input); % converts RGB image to grayscale
  figure(2); % creates a separate figure
  cropped_gray_image = imcrop(gray_image, [251 228 0 0]); % automatically crops the image according to [x y width height]
  imshow(cropped_gray_image); % displays the cropped up image
  [rows columns extraneous]= size(cropped_gray_image); % extracts information regarding number of pixels in the cropped image
  line_divisions = double(cropped_gray_image(1:rows,1:columns)); % converts the type of 'cropped_grayscale_image' to double
  mean_pixel_intensity = zeros(rows,1); % initializes a vector for storage of mean pixel intensity
  
  for i = 1:rows
    mean_pixel_intensity(i,1) = mean(line_divisions(i,:)); % computes the mean pixel intensity
  end

  matrix_mean_pixel_intensity = [matrix_mean_pixel_intensity, mean_pixel_intensity]; % concatenates mean pixel intensity of multiple images for multiple execution
  save matrix_mean_pixel_intensity 'matrix_mean_pixel_intensity' 'n'; % saves the vector 'matrix_mean_pixel_intensity' and the scalar 'n'
  % pause(0.1) % adds delay of 0.1 sec
end

%% Plotting results from previous cell
clear all; close all; clc;

load matrix_mean_pixel_intensity; % loads 'matrix_mean_pixel_intensity'
S = size(matrix_mean_pixel_intensity); % records size of matrix_mean_pixel_intensity
normalized_width = (1:1:S(1))'/S(1); % generates normalized width using number of rows of pixels
plot((linspace(1,5,n)),(matrix_mean_pixel_intensity(1,:))) % generates a plot of pixel intensity

%% Code for FFT and G-transform for spectrogram

clear all; close all; clc;
load matrix_mean_pixel_intensity; % loads the matrix matrix_mean_pixel_intensity
n = length(matrix_mean_pixel_intensity(1,:))-1;
T = 5; % time for which analysis is performed
t2 = linspace(0,T,n+1); t = t2(1:n); % time-domain broken down into n pts but since last point is the same so the point is excluded from t.
k = (2*pi/T)*[0:n/2-1 -n/2:-1]; ks = fftshift(k); % wave number 'k' and its shift 'ks'
S_local = matrix_mean_pixel_intensity(1,1:end-1);
S_min = min(matrix_mean_pixel_intensity(1,1:end-1));
S_max = max(matrix_mean_pixel_intensity(1,1:end-1));
S = (S_local - S_min)/(S_max - S_min);
St= fft(S); % Fourier transform of signal
width = 25; % width of filter
slide = linspace(0,5,n); % resolution in time for sliding window
spec = []; % add a null matrix

for j=1:length(slide)
  f = exp(-width*(t-slide(j)).^2); % filter moving in time
  Sf = f.*S; %filtered signal (multiplying filter with signal)
  Sft = fft(Sf); % Fourier transform of filtered signal
  subplot(3,1,1), plot(t,S,'k',t,f,'m'), title('original signal with a moving filter')
  subplot(3,1,2), plot(t,Sf,'k'), title('filtered signal')
  subplot(3,1,3), plot(ks, abs(fftshift(Sft)/max(abs(fftshift(Sft))))), title('the transform') % normalized plotting
  axis([-80 80 0 1])
  drawnow
  pause(0.01)
  spec = [spec; abs(fftshift(Sft))]; % adding rows in a matrix without having to override the previous value to plot a spectrogram
end

figure(2)
pcolor(slide,ks,spec.'),shading interp % plotting the spectrogram
set(gca, 'Ylim', [-100 100], 'Fontsize', [14])
colormap(hot)
xlabel('t')
ylabel('omega')
figure (3)
plot(ks, abs(fftshift(St))/max(abs(fftshift(St))))
