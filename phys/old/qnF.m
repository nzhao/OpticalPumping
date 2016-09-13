function f = qnF( atom, magB )
%QNF Summary of this function goes here
%   Detailed explanation goes here
    H=Hamiltonian(atom, magB);
    
    eigenG=eigH(H.uHg);
    f.gs.F2 = diag( eigenG.U' * atom.mat.uF2g * eigenG.U );
    f.gs.Fz = diag( eigenG.U' * atom.mat.uFjg(:,:,3) * eigenG.U);
    f.gs.F = 0.5*sqrt(1+4*f.gs.F2)-0.5;
    
    eigenE=eigH(H.uHe);
    f.es.F2 = diag( eigenE.U' * atom.mat.uF2e * eigenE.U );
    f.es.Fz = diag( eigenE.U' * atom.mat.uFje(:,:,3) * eigenE.U );
    f.es.F = 0.5*sqrt(1+4*f.es.F2)-0.5;
    
    f.maxF=atom.qn.I+atom.qn.J;
end

