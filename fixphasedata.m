function phase = fixphasedata(phase)

while max(find(diff(phase) > 300)) %(this indicates a jump)
    index = find(diff(phase) > 300)+1;
    phase(index:end) = phase(index:end) - 360;
end

end