function Aop=opticalPumpingMatixAop(atom,B,Kj,kappa)
%high-pressure optical pumping matrix, Eq(6.87)
fundamental_constants
H=Hamiltonian(atom,B);%Hamiltonian
eigVg=eigH(H.uHg);
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
%high-pressure optical pumping matrix
Aop=Asd-Kj(1)*Aex(:,:,1)-Kj(2)*Aex(:,:,2)-Kj(3)*Aex(:,:,3) ...
    -2*1i*kappa*(Kj(1)*SC(:,:,1)+Kj(2)*SC(:,:,2)+Kj(3)*SC(:,:,3));
end