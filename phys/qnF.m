function f = qnF( atom, magB )
%QNF Summary of this function goes here
%   Detailed explanation goes here
    H=Hamiltonian(atom, magB);
    
    eigenG=eigH(H.uHg);
    f.gF2 = diag( eigenG.U' * atom.mat.uF2g * eigenG.U );
    f.gFz = diag( eigenG.U' * atom.mat.uFjg(:,:,3) * eigenG.U);
    f.gF = 0.5*sqrt(1+4*f.gF2)-0.5;
    
    eigenE=eigH(H.uHe);
    f.eF2 = diag( eigenE.U' * atom.mat.uF2e * eigenE.U );
    f.eFz = diag( eigenE.U' * atom.mat.uFje(:,:,3) * eigenE.U );
    f.eF = 0.5*sqrt(1+4*f.eF2)-0.5;
    
    f.maxF=atom.qn.I+atom.qn.J;
end

