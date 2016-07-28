function HgC=LSHamiltonian(atom,B)
%Liouville-space Hamiltonian
H=Hamiltonian(atom,B);%Hamiltonian
eigVg=eigH(H.uHg);
HgC=Commutator(eigVg.H);%Liouville-space Hamiltonian
end