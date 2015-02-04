function rtf = stab_pz_cancel(orgtf)
% Xu Chen 
% maxchen@berkeley.edu
% 2011-06-02
rtf = minreal(tf(orgtf));