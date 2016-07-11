function G=evolutionOperator(atom,B,Gmc,beam)
    fundamental_constants
    
    H=Hamiltonian(atom,B);  %Hamiltonian
    uHg=H.uHg;  uHe=H.uHe;
    eigVg=eigH(uHg);  eigVe=eigH(uHe);
    eigV.Ug=eigVg.U; eigV.Eg=eigVg.E;
    eigV.Ue=eigVe.U; eigV.Ee=eigVe.E;

    Dj=dipoleOperator(eigV.Ug,eigV.Ue,atom);
    LS=LiouvilleSpace(atom);
    
    %the spontaneous emission, Eq. 5.50
    Asge=spontaneous_emission(atom,Dj);
    
    %the interaction matrix, Eq. 5.62
    tV=interaction(atom,beam,Dj);
    
    % Eqs. 5.90 - 5.93
    [Hee,Hge,Heg,Hgg]=rfShift(eigV.Ee,eigV.Eg,atom);

    %uniform-relaxation matrix, Eq. 5.111
    Acgg=relaxation(atom,LS);
    
    %G0=dark, G1=pumping, G2=collisions; dGdw=dG/dw 
    G0=zeros(LS.gt,LS.gt); G1=G0; G2=G0; dGdw=G0; 
    
    %index ranges for blocks 
    n1=1:atom.sw.ge^2; 
    n2=atom.sw.ge^2+1:atom.sw.ge^2+atom.sw.ge*atom.sw.gg; 
    n3=atom.sw.ge^2+atom.sw.ge*atom.sw.gg+1:atom.sw.ge^2+2*atom.sw.ge*atom.sw.gg;
    n4=atom.sw.ge^2+2*atom.sw.ge*atom.sw.gg+1:(atom.sw.ge+atom.sw.gg)^2; 
    
    G1(n1,n2)=kron(LS.Pe,tV)*1i/hbar;%upper off diagonal elements 
    G1(n1,n3)=-kron(conj(tV),LS.Pe)*1i/hbar; 
    G1(n2,n4)=-kron(conj(tV),LS.Pg)*1i/hbar; 
    G1(n3,n4)=kron(LS.Pg,tV)*1i/hbar; 
    G1=G1-G1';%add antihermitian conjugate 
    
    G2(n4,n4)=Gmc*Acgg; 
    
    dGdw(n2,n2)=1i*eye(atom.sw.ge*atom.sw.gg);%dG/dw 
    dGdw(n3,n3)=-dGdw(n2,n2); 
    
    G0(n1,n1)=diag(Hee(:)*1i/hbar+1/atom.pm.te);%diagonal elements 
    G0(n2,n2)=diag(Hge(:)*1i/hbar+1/(2*atom.pm.te)); 
    G0(n3,n3)=diag(Heg(:)*1i/hbar+1/(2*atom.pm.te)); 
    G0(n4,n4)=diag(Hgg(:)*1i/hbar); 
    G0(n4,n1)=-Asge/atom.pm.te;%repopulation by stimulated emission 
    
    G=G0+G1+G2+beam.Dw*dGdw;%total damping matrix 
end