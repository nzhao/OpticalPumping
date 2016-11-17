function res = v_dot_m( coeff, vect, mat )
%VECT_DOT_MAT Summary of this function goes here
%   Detailed explanation goes here
    res = coeff * ( vect(1)*mat(:,:,1) ...
                  + vect(2)*mat(:,:,2) ...
                  + vect(3)*mat(:,:,3));
end

