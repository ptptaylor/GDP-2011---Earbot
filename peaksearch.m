function [position,strength] = peaksearch(cross_n)


strength = -50;


for n=1:length(cross_n)
    
    if cross_n(n) > strength
        strength = cross_n(n);
        position = n;
    end

end