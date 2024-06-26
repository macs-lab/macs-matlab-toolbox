function ph = xsqueezephase(ph)
% function ph = xsqueezephase(ph)
% Normalize the phase values to be between plus and minus 180 degrees.
% 
% Xu Chen  
%  
% initial version: 
% 2013-05-30
% 
    ph=mod(ph+180,360)-180;
end