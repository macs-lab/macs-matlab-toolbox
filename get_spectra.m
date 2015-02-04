function varargout = get_spectra(...
    struc_data,Ts,varargin)
% function varargout = get_spectra(...
%     struc_data,Ts,data_indx,txt_ylabel,SW_plot)
% function varargout = get_wafer_time_spectra(...
%     file_nocomp,file_comp,SW_plot,SW_transient,Ts,txt_ylabel)
% 
%   compute the spectral of transfer functions based on the input-output
%   data
% 
% Xu Chen
% maxchen@berkeley.edu
% 2011-11-29
% 2012-05-18
% 2013-09-25
nall = nargin;
nvargin = length(varargin);
ni = nall - nvargin;
% error( nargchk(1, 4, ni) );
for ii = 1:2:nvargin
    if strcmpi(varargin{ii},'SW_plot')
        SW_plot = varargin{ii+1};
    elseif strcmpi(varargin{ii},'data_indx')
        data_indx = varargin{ii+1};
    elseif strcmpi(varargin{ii},'txt_ylabel')
        txt_ylabel = varargin{ii+1};
    elseif strcmpi(varargin{ii},'inputFilter')
        inputFilter = varargin{ii+1};
    elseif strcmpi(varargin{ii},'outputFilter')
        outputFilter = varargin{ii+1};        
    elseif strcmpi(varargin{ii},'SW_logPlot')
        SW_logPlot = varargin{ii+1};
    end
end

if ~exist('SW_plot','var')
    SW_plot = 1;
end
if ~exist('txt_ylabel','var')
    txt_ylabel = '%Track*256';
end
if ~exist('data_indx','var')
    data_indx = 1;
end
if ~exist('SW_logPlot','var')
    SW_logPlot = 1;
end
% if nargin < 5
%     SW_plot = 1;
%     if nargin < 4
%         txt_ylabel = '(Counts)';
%         if nargin < 3
%             data_indx = 1;
            if nargin < 2
                rpm = 5419;
                wedge = 296;
                Fs = rpm*wedge/60;
                Ts = 1/Fs;
                if nargin < 1
                    %                     struc_data = importdata('PCFdata_H3.mat');
                    [pcfFileName,pPath] = uigetfile(...
                        {'*.mat;','PCF Files (*.mat)';
                        '*.*',  'All Files (*.*)'}, ...
                        'Pick PCF file','.\');
                    
                    matFileName = pcfFileName;
                    
                    [~,w_d,wOrg] = pcfDataPrepare(matFileName,rpm,wedge);
                    % w_d: PES
                    % wOrg: RV and LV data
                    if isstruct(wOrg)
                        pNames = fieldnames(wOrg);
                        if 0
                            ptemp = 1;
                        else
                            commandwindow
                            disp('linear or rotational Vibration data?')
                            disp('	1:LV (default, press ENTER)')
                            disp('	2:RV')
                            b_godMode = 0;
                            if b_godMode
                                disp('	0:Both!')
                            end
                            ptemp = input(...
                                '   ');
                            while 1
                                if isempty(ptemp)
                                    ptemp = 1;
                                end
                                if any(ptemp == [1,2,0])
                                    break;
                                else
                                    disp('Wrong input');
                                    ptemp = input(...
                                        '   ');
                                end
                            end
                        end
                        b_LV = 0;
                        b_RV = 0;
                        if (ptemp==1)
                            for ii = 1:size(pNames,1)
                                k = findstr('linear', pNames{ii});
                                if ~isempty(k)
                                    filedIndx = ii;
                                    b_LV = 1;
                                    break;
                                end
                            end
                            w(:,:,:,1) = wOrg.(pNames{ii});
                            ssLV = w;
                        elseif ptemp == 2
                            for ii = 1:size(pNames,1)
                                k = findstr('rotation', pNames{ii});
                                if ~isempty(k)
                                    filedIndx = ii;
                                    b_RV = 1;
                                    break;
                                end
                            end
                            w(:,:,:,1) = wOrg.(pNames{ii});
                            ss = w;
                        elseif ptemp == 0
                            w(:,:,:,1) = wOrg.(pNames{1});
                            w(:,:,:,2) = wOrg.(pNames{2});
                            b_LV = 1;
                            b_RV = 1;
                        else
                        end
                    else
                        w = wOrg;
                    end
                    b_countAxis = 1;
                    if ~b_countAxis
                        w_d = w_d*100/256;
                        w = w*100/256;
                    end
                    struc_data.out = w_d;
                    struc_data.in = w;
                    %                     matFileName = 'PCFdata_H3.mat';
                    %                     [t,struc_data.out,struc_data.in] = pcfDataPrepare(matFileName,rpm,wedge);
                end
            end
%         end
%     end
% end

if ~exist('inputFilter','var')
    inputFilter = tf(1,1,Ts);
end
if ~exist('outputFilter','var')
    outputFilter = tf(1,1,Ts);
end
%% time-domain IO data
dataInput   = struc_data.in(data_indx:end);
dataOutput  = struc_data.out(data_indx:end);
%% additional data filtering % 2013-09-25
[numInputF,denInputF]   = tfdata(inputFilter,'v');
[numOutputF,denOutputF] = tfdata(outputFilter,'v');
dataInput               = filter(numInputF,denInputF,dataInput);
dataOutput              = filter(numOutputF,denOutputF,dataOutput);
%%
if 0
    Nfft = 512*2
    [mag,freq] = freq_resp_cal(dataOutput,dataInput,1/Ts,Nfft);
else
    [mag,freq] = freq_resp_cal(dataOutput,dataInput,1/Ts);
end
%
specDataInput           = specCale(dataInput,1/Ts);
specDataOutput          = specCale(dataOutput,1/Ts);
specDataInput.ampdb     = mag2db(specDataInput.amp);
specDataOutput.ampdb    = mag2db(specDataOutput.amp);
%
%
% error('tbd');
%
if nargout == 0 || SW_plot == 1
    
    figure, plot(dataInput,'r--')
    hold on
    plot(dataOutput)
    xlim([1, (length(dataInput))])
    xlabel 'Sample'
    ylabel(txt_ylabel)
    legend('tf: input','tf: output','location','best')
    
    %%
    
    indx = find(specDataInput.f>1);
    
    if 1
        if 1
            figure,
            if SW_logPlot
                semilogx(specDataInput.f(indx),specDataInput.ampdb(indx),'r--')
            else
                plot(specDataInput.f(indx),specDataInput.ampdb(indx),'r--')
            end
            hold on
            if SW_logPlot
                semilogx(specDataOutput.f(indx),specDataOutput.ampdb(indx))
            else
                plot(specDataOutput.f(indx),specDataOutput.ampdb(indx))
            end
            xlim([min(specDataInput.f(indx)),max(specDataInput.f(indx))])
            xlabel 'Frequency (Hz)'
            ylabel 'Magnitude (dB)'
            legend('tf: input','tf: output','location','best')
            grid
        else
            figure,
            semilogx(specDataInput.f,specDataInput.ampdb,'r--')
            hold on
            semilogx(specDataOutput.f,specDataOutput.ampdb)
            xlim([min(specDataInput.f),max(specDataInput.f)])
            xlabel 'Frequency (Hz)'
            ylabel 'Magnitude (dB)'
            legend('tf: input','tf: output','location','best')
            grid
        end
    else
        figure,
        subplot(211)
        semilogx(specDataInput.f,specDataInput.ampdb,'r--')
        hold on
        semilogx(specDataOutput.f,specDataOutput.ampdb)
        xlim([min(specDataInput.f),max(specDataInput.f)])
        xlabel 'Frequency (Hz)'
        ylabel 'Magnitude (dB)'
        legend('tf: input','tf: output','location','best')
        grid
        subplot(212)
        semilogx(specDataInput.f,specDataInput.pha,'r--')
        hold on
        semilogx(specDataOutput.f,specDataOutput.pha)
        xlim([min(specDataInput.f),max(specDataInput.f)])
        xlabel 'Frequency (Hz)'
        ylabel 'Phase (deg)'
    end
    
    IOamp = specDataOutput.amp./specDataInput.amp;
    IOpha = specDataOutput.pha-specDataInput.pha;
    
    %     figure,
    %     subplot(211)
    %     semilogx(specDataInput.f,20*log(IOamp))
    %     xlim([min(specDataInput.f),max(specDataInput.f)])
    %     xlabel 'Frequency (Hz)'
    %     ylabel 'Magnitude (dB)'
    %     grid
    %     subplot(212)
    %     semilogx(specDataInput.f,IOpha)
    %     xlim([min(specDataInput.f),max(specDataInput.f)])
    %     xlabel 'Frequency (Hz)'
    %     ylabel 'Phase (deg)'
    %     title 'IO transfer function'
    
    figure,
    subplot(211)
    if SW_logPlot
        semilogx(specDataInput.f,20*log(IOamp))
    else
        plot(specDataInput.f,20*log(IOamp))
    end
    xlim([min(specDataInput.f),max(specDataInput.f)])
    ylim([min(20*log(IOamp(indx))),max(20*log(IOamp(indx)))])
    xlabel 'Frequency (Hz)'
    ylabel 'Magnitude (dB)'
    title 'IO transfer function'
    grid
    subplot(212)
    if SW_logPlot
        semilogx(specDataInput.f,IOpha)
    else
        plot(specDataInput.f,IOpha)
    end
    xlim([min(specDataInput.f),max(specDataInput.f)])
    xlabel 'Frequency (Hz)'
    ylabel 'Phase (deg)'    
end
