function optical_matrix = AlkaliOpticalMatrix( gas, beam )
%ALKALIOPTICALMATRIX Summary of this function goes here
%   Detailed explanation goes here
    k = beam.refTransition; % k=1 for D1, k=2 for D2
    dimG = gas.atom.dim(1);
    dimE = gas.atom.dim(1+k);
    
    denom = VaporCell.DenominatorMat(gas, beam);
    tV =  VaporCell.AtomPhotonInteraction(gas, beam);
    tW = tV.*denom;
    
    eff_Hg = -tV'*tW;  eff_He = tV*tW';
    shift_g = real(eff_Hg); gamma_g = -imag(eff_Hg);
    shift_e = real(eff_He); gamma_e = -imag(eff_He);
    pump_rate_g = trace(gamma_g)/dimG;
    pump_rate_e = trace(gamma_e)/dimE;
    
    A_pump_gg = 1i*eff_Hg/pump_rate_g;
    A_pump_ee = 1i*eff_He/pump_rate_e;
    A_pump_ge = -1i*( kron(tW.', tV') - kron(tV.', tW') )/pump_rate_g;
    A_pump_eg = -1i*( kron(conj(tV), tW) - kron(conj(tW), tV) )/pump_rate_e;
    
    optical_matrix.dipole = tV;
    optical_matrix.W_mat = tW;
    optical_matrix.eff_Hg = eff_Hg;
    optical_matrix.eff_He = eff_He;
    
    optical_matrix.eff_shift_g = shift_g;
    optical_matrix.eff_gamma_g = gamma_g;
    optical_matrix.eff_shift_e = shift_e;
    optical_matrix.eff_gamma_e = gamma_e;

end

