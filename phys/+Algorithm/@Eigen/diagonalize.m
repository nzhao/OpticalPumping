function eigenList = diagonalize( obj )
%DIAGONALIZE Summary of this function goes here
%   Detailed explanation goes here

    eigenList=cell(size(obj.hamiltonian));
    for k=1:length(obj.hamiltonian)
        uH=obj.hamiltonian{k};
        [eigen.U,eigen.E]=eig(uH);%unsorted eigVenvectors and energies
        [~,n]=sort(-diag(eigen.E));%sort energies in descending order
        H=eigen.E(n,n); eigen.E=diag(H); eigen.U=eigen.U(:,n);%sorted Hg, Eg and Ug
        %eigen.H=H;
        
        eigenList{k}=eigen;
    end
    
    obj.transFreq=cell( length(obj.hamiltonian), length(obj.hamiltonian));
    for k=1:length(obj.hamiltonian)
        for q=1:length(obj.hamiltonian)
            Ek=eigenList{k}.E;
            Eq=eigenList{q}.E;
            
            obj.transFreq{k,q} = Ek*ones(1,length(Eq)) - ones(length(Ek),1)*Eq';
        end
    end
end

