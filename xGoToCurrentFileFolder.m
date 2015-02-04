function xGoToCurrentFileFolder(xfilepath)
% Xu Chen
% maxchen@berkeley.edu	
% 2012-07-24
[PATHSTR,NAME,EXT,VERSN] = fileparts(xfilepath);
cd (PATHSTR)