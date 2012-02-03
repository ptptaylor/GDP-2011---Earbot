%Function to search through cross-correlation for peak/peaks

function [position,strength] = peaksearch(cross_n,lag)


strength = -100;


for n=1:length(cross_n)
    
    if cross_n(n) > strength
        strength = cross_n(n);
        position = lag(n);
    end

end