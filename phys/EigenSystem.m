function sys = EigenSystem( atom, condition )
%EIGENSYSTEM Summary of this function goes here
%   Detailed explanation goes here

    %% Initialize GS Liouvillian 
    gs_lv_dim = atom.sw.ge * atom.sw.ge;
    sys.G=zeros(gs_lv_dim, gs_lv_dim);
    
    %% Eigen System
    H=Hamiltonian(atom, condition);
    sys.eigenG=Diagnalize(H.uHg);
    sys.eigenE=Diagnalize(H.uHe);
    sys.S=SpinOperator(atom, sys.eigenG);

    sys.hamiltonian=H;
    sys.G0 = 1i*circleC(sys.eigenG.H);
    sys.G  = sys.G + sys.G0;

end

