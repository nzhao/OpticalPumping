function hamiltonian = AlkaliHamiltonian( atom, magB )
%ALKALIHAMILTONIAN Summary of this function goes here
%   Detailed explanation goes here

    IS=atom.mat.IS; IJ1=atom.mat.IJ1; IJ2=atom.mat.IJ2;
    mu_gs=atom.mat.mu_gs; mu_e1=atom.mat.mu_e1; mu_e2=atom.mat.mu_e2;

    Ag = atom.parameters.hf_gs;
    Ae1= atom.parameters.hf_es1;
    Ae2= atom.parameters.hf_es2A;
    Be2= atom.parameters.hf_es2B;
    H_gs= Ag*IS - mu_gs(:,:,3)*magB; %uncoupled Hamiltonian
    H_e1= Ae1*IJ1 - mu_e1(:,:,3)*magB; %uncoupled Hamiltonian
    H_e2= Ae2*IJ2 - mu_e2(:,:,3)*magB ...
        + Be2*(3*IJ2^2+1.5*IJ2-atom.I*(atom.I+1)*atom.J2*(atom.J2+1)*eye(atom.dim2))...
            /(2*atom.I*(2*atom.I-1)*atom.J2*(2*atom.J2-1)); %uncoupled Hamiltonian


    hamiltonian{1} = H_gs;
    hamiltonian{2} = H_e1;
    hamiltonian{3} = H_e2;

end

