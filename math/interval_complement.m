function [B_A, union_A] = interval_complement( A, B )
%INTERVAL_COMPLEMENT Summary of this function goes here
%   Detailed explanation goes here
    A1 = interval_union(A).';
    A1row = A1(:).';
    count1 = sum(A1row < B(1));
    count2 = sum(A1row > B(2));
    if mod(count1, 2) == 0
        nIterval1 = count1/2;
        left = B(1);
    else
        nIterval1 = (count1+1)/2;
        left = A1row(count1+1);
    end
    
    if mod(count2, 2) == 0
        nInterval2 = count2/2;
        right = B(2);
    else
        nInterval2 = (count2+1)/2;
        right = A1row(end-count2);
    end
    
    A2 = A1(:, nIterval1+1:end-nInterval2);
    
    A2row = [left A2(:).' right];
    len = length(A2row);
    B_A = reshape(A2row, [2, len/2]).';
    union_A = A2.';

end

