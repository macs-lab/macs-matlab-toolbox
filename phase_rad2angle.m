function pha = phase_rad2angle(pha_rad)
% function pha = phase_rad2angle(pha_rad)
% Translates a phase from rad to angle, and normalize the result to be
% within plus minus 180 degrees.
% 
% Xu Chen
%  
pha = mod(pha_rad*180/pi+180,360)-180;