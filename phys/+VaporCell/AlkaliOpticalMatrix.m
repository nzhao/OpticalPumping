function optical_matrix = AlkaliOpticalMatrix( gas, beam )
%ALKALIOPTICALMATRIX Summary of this function goes here
%   Detailed explanation goes here
    dimG = gas.atom.dim(1);
    dimE = gas.atom.dim(1+beam.refTransition);
    %dimFull = dimG+dimE;
    
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
    
    A_collision_gg = zeros(dimG*dimG);
    A_collision_ee = zeros(dimE*dimE);
    A_collision_ge = zeros(dimG*dimG, dimE*dimE);
    A_collision_eg = zeros(dimE*dimE, dimG*dimG);

    gJ = gas.atom.gJ(1+beam.refTransition);
    Dj = gas.atom.operator.electric_dipole{beam.refTransition};
    A_spDecay_ge=(gJ/3)*( kron(conj(Dj(:,:,1)),Dj(:,:,1)) ...
                         +kron(conj(Dj(:,:,2)),Dj(:,:,2)) ...
                         +kron(conj(Dj(:,:,3)),Dj(:,:,3)) ); 
    
    %% export to structure
    optical_matrix.dipole = tV;
    optical_matrix.W_mat = tW;
    optical_matrix.eff_Hg = eff_Hg;
    optical_matrix.eff_He = eff_He;
    
    optical_matrix.eff_shift_g = shift_g;
    optical_matrix.eff_gamma_g = gamma_g;
    optical_matrix.eff_shift_e = shift_e;
    optical_matrix.eff_gamma_e = gamma_e;
    
    optical_matrix.A_p_gg = A_pump_gg; optical_matrix.A_p_ge = A_pump_ge;
    optical_matrix.A_p_eg = A_pump_eg; optical_matrix.A_p_ee = A_pump_ee;
    
    optical_matrix.A_c_gg = A_collision_gg;  optical_matrix.A_c_ge = A_collision_ge;
    optical_matrix.A_c_eg = A_collision_eg;  optical_matrix.A_c_ee = A_collision_ee;
    
    optical_matrix.A_s_ge = A_spDecay_ge;
    

end

