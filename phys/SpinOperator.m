function operators = SpinOperator( atom, eigen )
%SPINOPERATOR Summary of this function goes here
%   Detailed explanation goes here
    
    Sj=zeros(size(atom.mat.gSj));
    Fj=zeros(size(atom.mat.uFjg));
    for j=1:3
        Sj(:,:,j)=eigen.U'*atom.mat.gSj(:,:,j)*eigen.U;
        Fj(:,:,j)=eigen.U'*atom.mat.uFjg(:,:,j)*eigen.U;
    end
    
    gg2=atom.sw.gg*atom.sw.gg;
    sharpS=zeros(gg2, gg2, 3);   sharpF=zeros(gg2, gg2, 3);
    flatS=zeros(gg2, gg2, 3);    flatF=zeros(gg2, gg2, 3);
    circleCS=zeros(gg2, gg2, 3); circleCF=zeros(gg2, gg2, 3);
    lvS=zeros(gg2, 3);           lvF=zeros(gg2, 3);
    for k=1:3
        sj_k=Sj(:,:,k);
        sharpS(:,:,k)=sharp(sj_k);%sharp electron spin matrices
        flatS(:,:,k)=flat(sj_k);%flat electron spin matrices
        circleCS(:,:,k)=circleC(sj_k);
        lvS(:,k)=sj_k(:);
        
        fj_k=Fj(:,:,k);
        sharpF(:,:,k)=sharp(fj_k);
        flatF(:,:,k)=flat(fj_k);
        circleCF(:,:,k)=circleC(fj_k);
        lvF(:,k)=fj_k(:);
    end
    
    S.Sj=Sj;
    S.sharp=sharpS;
    S.flat=flatS;
    S.circleC=circleCS;
    S.lv=lvS;
    
    F.Fj=Fj;
    F.sharp=sharpF;
    F.flat=flatF;
    F.circleC=circleCF;
    F.lv=lvF;
    
    operators.S=S;
    operators.F=F;
end

