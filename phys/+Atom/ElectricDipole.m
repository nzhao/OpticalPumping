function Dj=ElectricDipole(atom, eigen_sys, pair)
%ELECTRICDIPOLE Summary of this function goes here
%   Detailed explanation goes here
    eigenG=eigen_sys{pair(1)};
    eigenE=eigen_sys{pair(2)};
    Ug=eigenG.U; Ue=eigenE.U;
    
    I=atom.I;    S=atom.J(pair(1)) ;   J=atom.J(pair(2));
    gI=atom.gI; gS=atom.gJ(pair(1));  gJ=atom.gJ(pair(2));
    sDs=zeros(gS,gJ,3); %spherical projections in electronic space
    for k=J:-1:-J
        for l=1:-1:-1
            for m=S:-1:-S
                if k+l==m
                    %sDs(S-m+1,J-k+1,2-l)=sqrt(3/gS)*cg(J,k,1,l,S,m);
                    sDs(S-m+1,J-k+1,2-l)=cg(J,k,1,l,S,m);
                end
            end
        end
    end
    sDj(:,:,1)=(-sDs(:,:,1)+sDs(:,:,3))/sqrt(2);
    sDj(:,:,2)=(-sDs(:,:,1)-sDs(:,:,3))/(1i*sqrt(2));
    sDj(:,:,3)=sDs(:,:,2); %Cartesian projections in electronic space
    
    [sz1, sz2, ~] =size(sDj);
    gDj=zeros( [gI*sz1, gI*sz2, 3] );
    for k=1:3
        gDj(:,:,k)=kron(eye(gI),sDj(:,:,k));% grave matrix;
    end

    Dj=zeros(size(gDj));
    for j=1:3;
        Dj(:,:,j)=Ug'*gDj(:,:,j)*Ue;
    end
end

