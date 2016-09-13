function eigen=Diagnalize(uH)
%putout the eigVen vectors and energies for ground and excited states:

    [eigen.U,eigen.E]=eig(uH);%unsorted eigVenvectors and energies
    [~,n]=sort(-diag(eigen.E));%sort energies in descending order
    H=eigen.E(n,n); eigen.E=diag(H); eigen.U=eigen.U(:,n);%sorted Hg, Eg and Ug
    eigen.H=H;
end