function G=dampingOperatorG(atom,B,Kj,kappa,Gmp)
fundamental_constants
[uHg,~]=Hamiltonian(atom,B);%Hamiltonian
eigVg=eigH(uHg);
%spin matrices in the energy basis Code5.3
for j=1:3
    Sj(:,:,j)=eigVg.U'*atom.mat.gSj(:,:,j)*eigVg.U;
end
for k=1:3
    sharpS(:,:,k)=sharp(Sj(:,:,k));%sharp electron spin matrices
    flatS(:,:,k)=flat(Sj(:,:,k));%flat electron spin matrices
end
SC=flatS-sharpS;%Liouville-space spin matrices
Asd=SdampingMat(SC);%S-damping matrix, Eq(6.88)
Aex=exchangeMat(flatS,sharpS);%exchange matrix, Eq(6.90)
Aop=opticalPumpingMat(Asd,Aex,SC,Kj,kappa);%high-pressure optical pumping matrix, Eq(6.87)
HgC=flat(eigVg.H)-sharp(eigVg.H);%Liouville-space Hamiltonian
G=1i*HgC/hbar+Gmp*Aop; %static damping operator
end