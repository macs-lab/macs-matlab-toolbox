function xGoToCurrentFileFolder(xfilepath)
% Xu Chen xchen@engr.uconn.edu
% University of Connecticut
% 2012-07-24
[PATHSTR,NAME,EXT,VERSN] = fileparts(xfilepath);
cd (PATHSTR)