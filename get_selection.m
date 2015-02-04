function varName = get_selection(defaultVal,valRange)
% varName = get_selection(varName,defaultVal,valRange)
% In a while loop, selects a numerical value from a range of values.
%
% Xu Chen xchen@engr.uconn.edu
% University of Connecticut
% initial version: 2013-09-29
%
if nargin < 2
    valRange = [];
end
if nargin < 1
    error('Insufficient input')
end
if 1
    varName = defaultLoopSel(input(''),defaultVal);
else
    varName = input('');
    varName = defaultLoopSel(varName,defaultVal);
end
if ~isempty(valRange)
    if all(varName ~= valRange) || ~isnumeric(varName)
        while 1
            if all(varName ~= valRange) || ~isnumeric(varName)
                disp    ('Wrong selection. Please re-select.')
                varName = defaultLoopSel(input(''),defaultVal);
            else
                break;
            end
        end
    end
end