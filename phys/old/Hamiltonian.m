function H = Hamiltonian(atom, condition) 
%uncoupled Hamiltonian for ground and excited states
    fundamental_constants

    magB=condition.magB;
    uIS=atom.mat.uIS; uIJ=atom.mat.uIJ;
    umug=atom.mat.umug; umue=atom.mat.umue;

    uHg=atom.pm.Ag*uIS - umug(:,:,3)*magB; %uncoupled Hamiltonian
    uHe=atom.pm.Ae*uIJ - umue(:,:,3)*magB; %Hamiltonian without quadrupole interaction

    if atom.qn.J>1/2&&atom.qn.I>1/2
        uHe = uHe+atom.pm.Be*(3*uIJ^2+1.5*uIJ-atom.qn.I*(atom.qn.I+1)*atom.qn.J*(atom.qn.J+1)*eye(atom.sw.ge))...
            /(2*atom.qn.I*(2*atom.qn.I-1)*atom.qn.J*(2*atom.qn.J-1)); %add quadrupole interaction
    end
    H.uHg = uHg*erg2MHz;
    H.uHe = uHe*erg2MHz;
end