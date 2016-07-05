function Asge=spontaneous_emission(gg,ge,gJ,Dj)
%Asge: the coupling matrix for spontaneous emission;
    Asge=zeros(gg*gg,ge*ge);
    for j=1:3 %sum over three Cartesian axes, Eq.5.50
        Asge=Asge+(gJ/3)*kron(conj(Dj(:,:,j)),Dj(:,:,j)); 
    end
end