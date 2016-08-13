function S = SpinOperator( atom, eigen )
%SPINOPERATOR Summary of this function goes here
%   Detailed explanation goes here
    
    Sj=zeros(size(atom.mat.gSj));
    for j=1:3
        Sj(:,:,j)=eigen.U'*atom.mat.gSj(:,:,j)*eigen.U;
    end
    
    gg2=atom.sw.gg*atom.sw.gg;
    sharpS=zeros(gg2, gg2, 3);
    flatS=zeros(gg2, gg2, 3);
    for k=1:3
        sharpS(:,:,k)=sharp(Sj(:,:,k));%sharp electron spin matrices
        flatS(:,:,k)=flat(Sj(:,:,k));%flat electron spin matrices
    end
    S.Sj=Sj;
    S.sharp=sharpS;
    S.flat=flatS;
    S.circleC=flatS-sharpS;%Liouville-space spin matrices

end

