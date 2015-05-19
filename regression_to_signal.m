% least squares fit to chemical waveform
clear all; close all; clc;

load matrix_mean_pixel_intensity.mat % loads 'matrix_mean_pixel_intensity'

time = linspace(0,5,n); % total duration of the signal
join = [(1:n);time; matrix_mean_pixel_intensity]'; % matches pixel intensity with time

y1 = join(8:89,3); % first half of the 1st peak is isolated
t1 = join(8:89,2); % duration for the first half of the 1st peak
y2 = join(89:152,3); % second half of the 1st peak is isolated
t2 = join(89:152,2); % duration for the second half of the 1st peak
plot(t1,y1,'rs', t2,y2,'bs'); xlabel('time (sec)'); ylabel('pixel intensity') % data points are plotted for the first peak
hold on
p1 = polyfit(t1,y1,1);p2 = polyfit(t2,y2,1); % linear fit to the two halves of the peak
plot(t1,polyval(p1,t1),'r', t2, polyval(p2,t2),'b'); % plotting the linear fits
SSE = sum((y1 - (p1(1)*t1 + p1(2))).^2);
SSY = sum((y1 - mean(y1)).^2);
SSE2 = sum((y2 - (p2(1)*t2 + p2(2))).^2);
SSY2 = sum((y2 - mean(y2)).^2);
R_squared1 = 1 - SSE/SSY; % R_squared for the first linear fit
R_squared2 = 1 - SSE2/SSY2; % R_squared for the second linear fit
R_squared_avg = 0.5*(R_squared1 + R_squared2); % average R_squared value

%% sinusoidal fit to chemical waveform
scatter(linspace(0,10,n), matrix_mean_pixel_intensity) % plotting the data points for the signal
hold on
B0 = mean(matrix_mean_pixel_intensity); % vertical shift
B1 = (max(matrix_mean_pixel_intensity(1,:)) - min(matrix_mean_pixel_intensity(1,:)))/2; % amplitude
B2 = 5; % phase (number of peaks)
B3 = 0; % phase shift (eyeball the Curve)
myFit = NonLinearModel.fit(linspace(0,10,n),matrix_mean_pixel_intensity, 'y ~ b0 + b1*sin(b2*x1 + b3)', [B0, B1, B2, B3]) % sinusoidal fit to the data. Note that all the coefficient estimates are very good except for b3 where any even integer is equally valid
%% look at the complete set of methods
methods(myFit)
%% Generate a plot
hold on
plot(linspace(0,10,n), myFit.Fitted)
hold off
