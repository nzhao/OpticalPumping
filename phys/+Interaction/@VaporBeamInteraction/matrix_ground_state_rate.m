function rateG=matrix_ground_state_rate( obj )
%MATRIX_GROUND_RATE Summary of this function goes here
%   Detailed explanation goes here

    gsG = obj.matrix_ground_state();
    id = eye(obj.parameter.dimG);  diagPos = find(id(:));
    rateG = gsG(diagPos, diagPos);
end

