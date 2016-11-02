function hamiltonian = AlkaliHamiltonian( atom, magB )
%ALKALIHAMILTONIAN Summary of this function goes here
%   Detailed explanation goes here

    IS=atom.mat.IS; mu=atom.mat.mu;
    A = {atom.parameters.hf_gs, ...
        atom.parameters.hf_es1, ...
        atom.parameters.hf_es2A};
    hamiltonian=cell(1, 3);
    for k=1:3
        hamiltonian{k} = A{k}*IS{k} - mu{k}(:,:,3)*magB/(2*pi*h_bar)*1e-6;
    end
    
    Be2= atom.parameters.hf_es2B;
    hamiltonian{3} = hamiltonian{3} + ...
                   + Be2*(3*IS{3}^2+1.5*IS{3}-atom.I*(atom.I+1)*atom.J(3)*(atom.J(3)+1)*eye(atom.dim(3))) ...
                   /(2*atom.I*(2*atom.I-1)*atom.J(3)*(2*atom.J(3)-1)); %uncoupled Hamiltonian

end

