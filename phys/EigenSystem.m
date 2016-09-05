function eigen = EigenSystem( atom, condition )
%EIGENSYSTEM Summary of this function goes here
%   Detailed explanation goes here

    %% Initialize GS Liouvillian 
    gs_lv_dim = atom.sw.ge * atom.sw.ge;
    eigen.G=zeros(gs_lv_dim, gs_lv_dim);
    
    %% Eigen System
    H=Hamiltonian(atom, condition);
    eigen.eigenG=Diagnalize(H.uHg);
    eigen.eigenE=Diagnalize(H.uHe);
    eigen.operators=SpinOperator(atom, eigen.eigenG);

    eigen.hamiltonian=H;
    eigen.G0 = 1i*circleC(eigen.eigenG.H);
    eigen.G  = eigen.G + eigen.G0;

end

