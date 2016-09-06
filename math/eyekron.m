function kronMat= eyekron( dim, mat )
%EYEKRON Summary of this function goes here
%   Detailed explanation goes here
    kronMat=zeros( dim*size(mat,1), dim*size(mat,2), size(mat,3));
    for i = 1:size(mat, 3)
        kronMat(:,:,i) = kron( eye(dim),  mat(:,:,i) );
    end

end

