function G=evolutionOperator(atom,B,Gmc,Dw,tEj)
    fundamental_constants
    sw=atom.sw;
    
    [uHg,uHe]=Hamiltonian(atom,B);  %Hamiltonian
    eigVg=eigH(uHg);  eigVe=eigH(uHe);
    eigV.Ug=eigVg.U; eigV.Eg=eigVg.E;
    eigV.Ue=eigVe.U; eigV.Ee=eigVe.E;


    Dj=dipoleOperator(eigV.Ug,eigV.Ue,atom.qn.I,atom.qn.S,atom.qn.J);
    LS=LiouvilleSpace(sw.gg,sw.ge);
    
    %Asge: the coupling matrix for spontaneous emission;
    Asge=zeros(sw.gg*sw.gg,sw.ge*sw.ge);
    for j=1:3 %sum over three Cartesian axes, Eq.5.50
        Asge=Asge+(sw.gJ/3)*kron(conj(Dj(:,:,j)),Dj(:,:,j)); 
    end
    
    %the interaction matrix, Eq. 5.62
    tV=interaction(sw.ge,sw.gg,atom.D,Dj,tEj);
    
    % Eqs. 5.90 - 5.93
    [Hee,Hge,Heg,Hgg]=rfShift(eigV.Ee,eigV.Eg,sw.ge,sw.gg);

    %uniform-relaxation matrix, Eq. 5.111
    Acgg=eye(sw.gg*sw.gg)-LS.cPg*LS.rPg/sw.gg;
    
    %G0=dark, G1=pumping, G2=collisions; dGdw=dG/dw 
    G0=zeros(LS.gt,LS.gt); G1=G0; G2=0; dGdw=G0; 
    
    %index ranges for blocks 
    n1=1:sw.ge^2; 
    n2=sw.ge^2+1:sw.ge^2+sw.ge*sw.gg; 
    n3=sw.ge^2+sw.ge*sw.gg+1:sw.ge^2+2*sw.ge*sw.gg;
    n4=sw.ge^2+2*sw.ge*sw.gg+1:(sw.ge+sw.gg)^2; 
    
    G1(n1,n2)=kron(LS.Pe,tV)*1i/hbar;%upper off diagonal elements 
    G1(n1,n3)=-kron(conj(tV),LS.Pe)*1i/hbar; 
    G1(n2,n4)=-kron(conj(tV),LS.Pg)*1i/hbar; 
    G1(n3,n4)=kron(LS.Pg,tV)*1i/hbar; 
    G1=G1-G1';%add antihermitian conjugate 
    
    G2(n4,n4)=Gmc*Acgg; 
    
    dGdw(n2,n2)=1i*eye(sw.ge*sw.gg);%dG/dw 
    dGdw(n3,n3)=-dGdw(n2,n2); 
    
    G0(n1,n1)=diag(Hee(:)*1i/hbar+1/atom.pm.te);%diagonal elements 
    G0(n2,n2)=diag(Hge(:)*1i/hbar+1/(2*atom.pm.te)); 
    G0(n3,n3)=diag(Heg(:)*1i/hbar+1/(2*atom.pm.te)); 
    G0(n4,n4)=diag(Hgg(:)*1i/hbar); 
    G0(n4,n1)=-Asge/atom.pm.te;%repopulation by stimulated emission 
    
    G=G0+G1+G2+Dw*dGdw;%total damping matrix 
end