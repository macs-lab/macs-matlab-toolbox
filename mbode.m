function mbode(sys,fi,ff,op)
%SBODE  Generates a Bode plot.
%
%   SBODE(sys,fi,ff,op) plots the frequency response of sys.
%   fi and ff specify the start and end frequency in Hz. op is
%   plot option. Default values for fi, ff and op are 100, 10000
%   and 'b-'.
%
%   See also sBode_mag, sBode_magl, sBode_mul and sBode_add.

%   Steve Zheng 9-3-2007
%   Copyright Steve Zheng MSC, UC Berkeley.
% 
%  modified by Xu Chen maxchen@berkeley.edu on 2011-04-26
% 

% ff = 6000;
% fi = 10;
% sys = tf(sysd_di_delay);


if ~exist('op')
    op = 'b-';
end

if ~exist('ff')
    ff = 10000;
end
if ~exist('fi')
    fi = 1;
end

W = logspace(log10(fi*2*pi),log10(ff*2*pi),600);

[MAG,PHASE] = BODE(sys,W);
MAG = MAG(:);
PHASE = mod(PHASE(:),360);
for idx = 1:length(PHASE)
    if PHASE(idx) > 180
        PHASE(idx) = PHASE(idx)-360;
    end
end


subplot(211),
semilogx(W/2/pi,20*log10(MAG),op),
grid on,ylabel('Magnitude (dB)'),hold on
xlim([fi,ff])
subplot(212),
semilogx(W/2/pi,PHASE,op),
grid on,xlabel('Frequency (Hz)'),ylabel('Phase (deg)'),hold on    
xlim([fi,ff])