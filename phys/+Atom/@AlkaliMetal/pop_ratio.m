function [ aRatio, bRatio ] = pop_ratio( obj, pop )
%POP_RATIO Summary of this function goes here
%   Detailed explanation goes here

    bPop=pop(1:2*obj.b+1);
    aPop=pop(end-2*obj.a:end);

    bRatio = zeros(1, length(bPop)-1);
    for k=1:length(bPop)-1
        bRatio(k) = bPop(k)/bPop(k+1);
    end

    aRatio = zeros(1, length(aPop)-1);
    for k=1:length(aPop)-1
        aRatio(k) = aPop(k+1)/aPop(k);
    end
end

