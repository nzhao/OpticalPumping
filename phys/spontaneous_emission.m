function Asge=spontaneous_emission(atom,Dj)
gg=atom.sw.gg;ge=atom.sw.ge;gJ=atom.sw.gJ;
%Asge: the coupling matrix for spontaneous emission;
    Asge=zeros(gg*gg,ge*ge);
    for j=1:3 %sum over three Cartesian axes, Eq.5.50
        Asge=Asge+(gJ/3)*kron(conj(Dj(:,:,j)),Dj(:,:,j)); 
    end
end