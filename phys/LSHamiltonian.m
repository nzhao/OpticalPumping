function HgC=LSHamiltonian(atom,B)
%Liouville-space Hamiltonian
H=Hamiltonian(atom,B);%Hamiltonian
eigVg=eigH(H.uHg);
HgC=flat(eigVg.H)-sharp(eigVg.H);%Liouville-space Hamiltonian
end