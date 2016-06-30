function [uHg,uHe] = Hamiltonian(atom,B) 
%uncoupled Hamiltonian for ground and excited states

fundamental_constants
%statistical weights
sw=statistical_weights(atom.qn.I,atom.qn.S,atom.qn.J);

[aIjg,gSj,aIje,gJj]=spin_matrices(atom.qn.I,atom.qn.S,atom.qn.J,sw.gI,sw.gS,sw.gJ);%operators in uncoupled space
LgS=2.00231;% Lande g-value of S1/2 state
LgJ=sw.gJ/3;%approximate Lande g-value of PJ state
 %uncoupled spin matrices
for k=1:3;% uncoupled magnetic moment operators
    umug(:,:,k)=-LgS*muB*gSj(:,:,k)+(atom.pm.muI/(atom.qn.I+eps))*aIjg(:,:,k);
    umue(:,:,k)=-LgJ*muB*gJj(:,:,k)+(atom.pm.muI/(atom.qn.I+eps))*aIje(:,:,k);
end
uIS=matdot(aIjg,gSj); %uncoupled I.S
uIJ=matdot(aIje,gJj);%uncoupled I.J
uHg=atom.pm.Ag*uIS-umug(:,:,3)*B; %uncoupled Hamiltonian
uHe=atom.pm.Ae*uIJ - umue(:,:,3)*B;%Hamiltonian without quadrupole interaction
if atom.qn.J>1/2&&atom.qn.I>1/2
    uHe = uHe+atom.pm.Be*(3*uIJ^2+1.5*uIJ-atom.qn.I*(atom.qn.I+1)*atom.qn.J*(atom.qn.J+1)*eye(sw.ge))...
        /(2*atom.qn.I*(2*atom.qn.I-1)*atom.qn.J*(2*atom.qn.J-1)); %add quadrupole interaction
end
end