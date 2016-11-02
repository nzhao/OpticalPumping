function tV=AtomPhotonInteraction(atom, beam, condition)
    fundamental_constants

    H=Hamiltonian(atom, condition);
    eigenG=Diagnalize(H.uHg);
    eigenE=Diagnalize(H.uHe);
    Dj=ElectricDipole(atom, eigenG, eigenE);
    
    ge=atom.sw.ge;gg=atom.sw.gg;D=atom.D;tEj=beam.tEj;
    tV=zeros(ge,gg);
    for j=1:3 %sum over three Cartesian axes
        tV=tV-D*Dj(:,:,j)'*tEj(j);
    end
    tV=tV*erg2MHz;
end