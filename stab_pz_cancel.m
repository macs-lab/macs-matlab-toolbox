function rtf = stab_pz_cancel(orgtf)
%   Copyright (c) 2008-, 
%   Xu Chen xchen@engr.uconn.edu
%   University of Connecticut
rtf = minreal(tf(orgtf));