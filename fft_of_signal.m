% single-sided amplitude spectrum.

L= size(signal,1); % length of matrix, signal = [time, resistance];
Fs = 50; % sampling rate in Hz

y = electrode80(:,2); % resistance;

NFFT = 2^nextpow2(L); % Next power of 2 from length of y

Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

plot(f,2*abs(Y(1:NFFT/2+1))) % plot of single-sided amplitude spectrum

title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')
