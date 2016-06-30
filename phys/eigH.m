function eigV=eigH(uH)
%putout the eigVen vectors and energies for ground and excited states:

    [eigV.U,eigV.E]=eig(uH);%unsorted eigVenvectors and energies
    [~,n]=sort(-diag(eigV.E));%sort energies in descending order
    H=eigV.E(n,n); eigV.E=diag(H); eigV.U=eigV.U(:,n);%sorted Hg, Eg and Ug

end