function [uHg,uHe] = Hamiltonian(atom,B) 
%uncoupled Hamiltonian for ground and excited states
    fundamental_constants

    aIjg=atom.mat.aIjg; gSj=atom.mat.gSj;
    aIje=atom.mat.aIje; gJj=atom.mat.gJj;

    %uncoupled spin matrices
    for k=1:3;% uncoupled magnetic moment operators
        umug(:,:,k)=-atom.LgS*muB*gSj(:,:,k) + (atom.pm.muI/(atom.qn.I+eps))*aIjg(:,:,k);
        umue(:,:,k)=-atom.LgJ*muB*gJj(:,:,k) + (atom.pm.muI/(atom.qn.I+eps))*aIje(:,:,k);
    end
    uIS=matdot(aIjg,gSj); %uncoupled I.S
    uIJ=matdot(aIje,gJj);%uncoupled I.J
    uHg=atom.pm.Ag*uIS - umug(:,:,3)*B; %uncoupled Hamiltonian
    uHe=atom.pm.Ae*uIJ - umue(:,:,3)*B;%Hamiltonian without quadrupole interaction

    if atom.qn.J>1/2&&atom.qn.I>1/2
        uHe = uHe+atom.pm.Be*(3*uIJ^2+1.5*uIJ-atom.qn.I*(atom.qn.I+1)*atom.qn.J*(atom.qn.J+1)*eye(atom.sw.ge))...
            /(2*atom.qn.I*(2*atom.qn.I-1)*atom.qn.J*(2*atom.qn.J-1)); %add quadrupole interaction
    end
end