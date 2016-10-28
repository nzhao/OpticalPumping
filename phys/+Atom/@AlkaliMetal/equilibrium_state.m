function rho = equilibrium_state( obj, transition)
%INIT_STATE Summary of this function goes here
%   Detailed explanation goes here
    dimG = obj.dim(1);
    dimE = obj.dim(1+transition);
    matG = eye(dimG) / dimG;
    mat = [zeros(dimE),       zeros(dimE, dimG); ...
           zeros(dimG, dimE), matG];
    rho = Algorithm.DensityMatrix(obj, [Atom.Subspace.GS, 1+transition]);
    rho.set_matrix(mat);
end

