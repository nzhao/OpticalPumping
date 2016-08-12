function H = Hamiltonian(atom,magB) 
%uncoupled Hamiltonian for ground and excited states
    fundamental_constants

    uIS=atom.mat.uIS; uIJ=atom.mat.uIJ;
    umug=atom.mat.umug; umue=atom.mat.umue;

    H.uHg=atom.pm.Ag*uIS - umug(:,:,3)*magB; %uncoupled Hamiltonian
    H.uHe=atom.pm.Ae*uIJ - umue(:,:,3)*magB; %Hamiltonian without quadrupole interaction

    if atom.qn.J>1/2&&atom.qn.I>1/2
        H.uHe = H.uHe+atom.pm.Be*(3*uIJ^2+1.5*uIJ-atom.qn.I*(atom.qn.I+1)*atom.qn.J*(atom.qn.J+1)*eye(atom.sw.ge))...
            /(2*atom.qn.I*(2*atom.qn.I-1)*atom.qn.J*(2*atom.qn.J-1)); %add quadrupole interaction
    end
end