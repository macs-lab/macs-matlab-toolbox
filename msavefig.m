function varargout = msavefig(varargin)
% function varargoug = msavefig(varargin)
% 
%  Saves an opened figure to .fig .eps .emf and .pdf files to the current
%  or the original figure directory.
% 
%  If the figure is originally opened from a figure file, the original
%  directory and figure will be preserved. Otherwise, users are promoted to
%  enter the file name and the figure will be saved to the current
%  directory.
%   
% Xu Chen  
%  

% distFig;
if nargin == 0
    figureHandle = gcf;
    SW_PDF = 0;
elseif nargin == 1
    figureHandle = varargin{1};   
elseif nargin == 2
    figureHandle = varargin{1};   
    SW_PDF = varargin{2};
end
h = get(figureHandle,'filename'); % get the full file name including the path
if isempty(h)
    filePath = '';
    fileName = inputdlg('Input figure name'); % ask for a name
    saveName = fileName{1};
%     saveNameFig = [filePath,'\\',fileName,'.fig']
%     saveNameEps = [filePath,'\\',fileName,'.eps']
%     saveNameEmf = [filePath,'\\',fileName,'']
else
    % regular expression: find the \ in the full name
    [~,tempIndx] = regexp(h,'\\','match'); 
    filePath = h(1:tempIndx(end)-1);
    % find now the . right before the file extension
    [~,dotIndx] = regexp(h,'\.','match'); 
    fileName = h(tempIndx(end)+1:dotIndx(end)-1);    
    saveName = [filePath,'\',fileName];
end
saveas(gcf,[saveName,'.fig'])
saveas(gcf,[saveName,'.png'])
% saveas(gcf,[saveName,'.pdf'])
savefig(saveName,'pdf')
try
    saveas(gcf,[saveName,'.emf'])
    saveas(gcf,saveName,'eps2c')
    if ispc
    dosCmd = ['start "" "C:\Program Files (x86)\Metafile to EPS Converter\metafile2eps.exe" ', saveName, '.emf',' ',saveName,'.eps'];
    dos(dosCmd)
    end
catch
    varargout{1} = 0;
    saveas(gcf,saveName,'eps2c')
end

if SW_PDF
    % trying a so-called export_fig package that is supposed to work
    % not quite what i wanted though
    %     saveNamePDF = [saveName,'.pdf'];
    %     export_fig saveNamePDF;
    
    % directly saving to pdf gives not accurate margins
    % need to do a margin control first
    set(gcf,'PaperUnits','normalized');
    set(gcf,'PaperPosition', [0 0 1 1]);
    % now save
    saveas(gcf,saveName,'pdf')    
    
    % matlab can directly evaluate system commands. LaTeX provides this
    % pdfcrop function which is supposed to work, not in my case though.
    %     system(['pdfcrop ',saveName,'.pdf ',saveName,'.pdf']);
end