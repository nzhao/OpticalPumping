function g0_term = calc_g0_term( obj, k )
%CALC_G0_TERM Summary of this function goes here
%   Detailed explanation goes here

    gas = obj.gasList{k};
    g0_term = [];
    if strcmp(gas.type, 'vapor')
        hamiltonian = diag( gas.atom.eigen.getEnergy(Atom.Subspace.GS) );
        g0_term = 1i*circleC(hamiltonian);
    end

end

