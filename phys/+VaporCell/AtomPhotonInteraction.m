function tV = AtomPhotonInteraction( gas, beam )
%ATOMPHOTONINTERACTION Summary of this function goes here
%   Detailed explanation goes here

    if strcmp(beam.refTransition, 'D1')
        D = gas.atom.parameters.dipole_D1;
        Dj = gas.atom.operator.electric_dipole{1};
        dimG = gas.atom.dim(1);
        dimE = gas.atom.dim(2);
    elseif strcmp(beam.refTransition, 'D2')
        D = gas.atom.parameters.dipole_D2;
        Dj = gas.atom.operator.electric_dipole{2};
        dimG = gas.atom.dim(1);
        dimE = gas.atom.dim(3);
    end
    
    tV=zeros(dimE,dimG);
    for j=1:3 %sum over three Cartesian axes
        tV=tV-D*Dj(:,:,j)'*beam.vectorE(j);
    end

end

