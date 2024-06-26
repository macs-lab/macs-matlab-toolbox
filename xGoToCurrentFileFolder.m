function xGoToCurrentFileFolder(xfilepath)
% Xu Chen  
%  
% 2012-07-24
[PATHSTR,NAME,EXT,VERSN] = fileparts(xfilepath);
cd (PATHSTR)