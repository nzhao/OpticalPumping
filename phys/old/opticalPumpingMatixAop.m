function op=opticalPumpingMatixAop(atom,B,Kj,kappa)
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
op.SC=flatS-sharpS;%Liouville-space spin matrices
op.Asd=SdampingMat(op.SC);%S-damping matrix, Eq(6.88)
op.Aex=exchangeMat(flatS,sharpS);%exchange matrix, Eq(6.90)
%high-pressure optical pumping matrix
op.Aop=op.Asd-Kj(1)*op.Aex(:,:,1)-Kj(2)*op.Aex(:,:,2)-Kj(3)*op.Aex(:,:,3) ...
    -2*1i*kappa*(Kj(1)*op.SC(:,:,1)+Kj(2)*op.SC(:,:,2)+Kj(3)*op.SC(:,:,3));
op.Sj=Sj;
end