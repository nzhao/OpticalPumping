function g0_term = calc_g0_term( obj, k )
%CALC_G0_TERM Summary of this function goes here
%   Detailed explanation goes here

    gas = obj.gasList{k};
    g0_term = [];
    if strcmp(gas.type, 'vapor')
        hamiltonian = diag( gas.atom.eigen.getEnergy(Atom.Subspace.GS) );
        zeeman_x = gas.atom.matEigen.zeeman_terms(:,:,1);
        zeeman_y = gas.atom.matEigen.zeeman_terms(:,:,2);
        g0_term = 1i*circleC(hamiltonian+zeeman_x+zeeman_y);
    end

end

