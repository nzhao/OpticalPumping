function reOrderData = reOrder( data )
%REORDER Summary of this function goes here
%   Detailed explanation goes here
    dim = sqrt(size(data, 1));
    id = eye(dim);
    diagPos = find(id)'; offDiagPos = find(1-id)';
    reOrderIndex = [diagPos, offDiagPos];
    
    if size(data, 2) > 1 % matrix
        reOrderData = data(reOrderIndex, reOrderIndex);
    else % vector
        reOrderData = data(reOrderIndex);
    end

end

