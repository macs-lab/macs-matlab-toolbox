function [mag,Freq]=freq_resp_cal(y,u,Fs)
% This function computes the magnitude and phase of the frequency response between u (input)
% and y (output) using the spectral analysis.
% 
% Xu Chen xchen@engr.uconn.edu
% University of Connecticut

FRF = [];

%Fs = 800;
Ts = 1/Fs;
fmin_visu = 1;
fmax_visu = round(Fs/2);

if 1
    L       = length(u);
%     if b_autoNFFT
        NFFT    = 2^nextpow2(L);
%     end
else
    Nfft = 2048/2;
end
window = hanning(Nfft);
noverlap = 0.75*Nfft;

%[Txy,Freq] = tfe(u,y,Nfft,Fs,window,noverlap) ;
[Txy,Freq] = tfestimate(u,y,window,noverlap,Nfft,Fs) ;

ind = find(Freq>fmin_visu & Freq<fmax_visu);

figure;
plot(Freq(ind),20*log10(abs(Txy(ind))));grid
title('Magnitude of the frequency response of the secondary path obtained by spectral analysis')
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');


% 
% figure;
% semilogx(Freq(ind),20*log10(abs(Txy(ind))));grid
% title('Magnitude of the frequency response of the secondary path obtained by spectral analysis')
% xlabel('Frequency (Hz)');
% ylabel('Magnitude (dB)');

% figure;
% plot(Freq(ind),180/pi*(angle(Txy(ind))));grid
% xlabel('Fréquency (Hz)');
% ylabel('Phase (°)');

mag=20*log10(abs(Txy));
%pha=180/pi*(angle(Txy));