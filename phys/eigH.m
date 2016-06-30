function eigV=eigH(uHg,uHe)
%putout the eigVen vectors and energies for ground and excited states:
%eig.Eg, eig.Ug, eig.Ee, eig.Ue

[eigV.Ug,eigV.Eg]=eig(uHg);%unsorted eigVenvectors and energies
[x,n]=sort(-diag(eigV.Eg));%sort energies in descending order
Hg=eigV.Eg(n,n); eigV.Eg=diag(Hg); eigV.Ug=eigV.Ug(:,n);%sorted Hg, Eg and Ug


[eigV.Ue,eigV.Ee]=eig(uHe);%unsorted eigVenvectors and energies
[x,n]=sort(-diag(eigV.Ee));%sort energies in descending order
He=eigV.Ee(n,n); eigV.Ee=diag(He); eigV.Ue=eigV.Ue(:,n);%sorted He, Ee, and Ue
end