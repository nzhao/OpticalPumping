function EB=EnergyBasis(atom,B)
%mug matrices in the energy basis
%the low-field labels f and m for energy basis of ground states
H=Hamiltonian(atom,B);%Hamiltonian
eigVg=eigH(H.uHg);  Ug=eigVg.U; 
for j=1:3;
    EB.mug(:,:,j)=Ug'*H.umug(:,:,j)*Ug;
    Ijg(:,:,j)=Ug'*atom.mat.aIjg(:,:,j)*Ug;
    Sj(:,:,j)=Ug'*atom.mat.gSj(:,:,j)*Ug;
end
    I=atom.qn.I; S=atom.qn.S;
    fg=round(-1+sqrt(1+4*(2*diag(Ug'*atom.mat.uIS*Ug)+I*(I+1)+S*(S+1))))/2;
    mg=round(2*diag(Ijg(:,:,3)+Sj(:,:,3)))/2;
        %the left and right versions of f and m (from Schrodinger space to
        %Liouville space)
        EB.x=kron(fg,ones(1,atom.sw.gg)); EB.fgl=EB.x(:); %left f label
        EB.x=EB.x'; EB.fgr=EB.x(:);%right f label
        EB.x=kron(mg,ones(1,atom.sw.gg)); EB.mgl=EB.x(:); %left m label
        EB.x=EB.x'; EB.mgr=EB.x(:);%right m label
end