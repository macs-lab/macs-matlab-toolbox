function [freq] = xmaglin(...
    sys_siso,...
    fig_color,...
    line_style,...
    fig_line_width,...
    freq_Hz)
% function xbode(sys_siso,fig_color,line_style,fig_line_width)
%
% Xu Chen  
%  
% Initial Version: 2011-04-26
ni = nargin;
no = nargout;
error( nargchk(1, 5, ni) );
if nargin <5
    SW_FREQ = 0;
else
    SW_FREQ = 1;
end
if nargin <4
    fig_line_width = 1.5;
end
if nargin <3
    line_style = '-';
end
if nargin <2
    fig_color = 'b';
end

if fig_line_width < 0.5
    fig_line_width = 0.5;
end

[Mnum,Nnum,MMnum] = size(sys_siso);
fig_num = gcf;
for mm = 1:MMnum
    if mm == 1
        if SW_FREQ
            try
                [mag,ph,w]=bode(sys_siso(1,1,mm),freq_Hz*2*pi);
            catch
                [mag,ph,w]=bode(ss(sys_siso(1,1,mm)),freq_Hz*2*pi);
            end
        else
            try
                [mag,ph,w]=bode(sys_siso(1,1,mm));
            catch
                [mag,ph,w]=bode(ss(sys_siso(1,1,mm)));
            end
        end
    else
        try
            [mag,ph,w]=bode(sys_siso(1,1,mm),freq*2*pi);
        catch
            [mag,ph,w]=bode(ss(sys_siso(1,1,mm)),freq*2*pi);
        end
    end
    if mm == 1
        f = w/(2*pi);
%         FreqMin=10^fix(log10(min(f))); % 2011-04-26
        FreqMin = min(f);
        FreqMax=max(f);
        freq = f; % for next loop
    end
    ph          = mod(ph+180,360)-180;
    magnitude   = mag(1,1,:);
    magnitude   = magnitude(:);
    phase       = ph(1,1,:);
    phase       = phase(:);
    
    h1 = plot(f,20*log10(abs(magnitude)),...
        'LineStyle',line_style,...
        'Color',fig_color,'LineWidth',fig_line_width);
    grid on;
    hold on;
    ylabel('Gain (dB)');
    xlabel('Frequency (Hz)');
    %      line_color_num=line_color_num+1;
    %      axis([h1 h2],'equal')
end
set( gca, 'xlim',  [FreqMin FreqMax]);
