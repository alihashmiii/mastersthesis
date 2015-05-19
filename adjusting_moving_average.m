% filtering moving averages.

Fs=50; % sample rate in Hz
window = 4; % window size for filter
B = ones(1,Fs*window)/Fs/window;
delay = round((Fs*window-1)/2);
electrodenoshift = filter(B,1,[electrode80(:,2); zeros(delay,1)]);
ensnd = electrodenoshift( (delay+1):end ); % removal of moving average

plot(electrode80(:,1),electrode80(:,2)/10^3); xlabel('time (s)'); ylabel('Resistance (kOhm)')
figure(2)
plot(electrode80(:,1),ensnd/10^3); xlabel('time (s)'); ylabel('Average resistance (kOhm)')
figure(3)
plot(electrode80(:,1),electrode80(:,2)-ensnd); xlabel('time (s)'); ylabel('Filtered signal')
