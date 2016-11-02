function tV = AtomPhotonInteraction( gas, beam )
%ATOMPHOTONINTERACTION Summary of this function goes here
%   Detailed explanation goes here
    k = beam.refTransition; % k=1 for D1, k=2 for D2
    D = gas.atom.parameters.dipole(k);
    Dj = gas.atom.operator.electric_dipole{k};
    dimG = gas.atom.dim(1);
    dimE = gas.atom.dim(1+k);
    
    tV=zeros(dimE,dimG);
    for j=1:3 
        tV=tV-D*Dj(:,:,j)'*beam.vectorE(j);
    end
    tV = tV / (h_bar * 2*pi) * 1e-6; % Dipole coupling matrix in MHz

end

