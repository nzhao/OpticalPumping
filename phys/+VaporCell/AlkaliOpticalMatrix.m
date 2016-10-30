function optical_matrix = AlkaliOpticalMatrix( gas, beam )
%ALKALIOPTICALMATRIX Summary of this function goes here
%   Detailed explanation goes here
    
    Dk = beam.refTransition; % D1 or D2
    dimG = gas.atom.dim(1);
    dimE = gas.atom.dim(1+Dk);
    %dimFull = dimG+dimE;
    
    denom = VaporCell.DenominatorMat(gas, beam);
    tV =  VaporCell.AtomPhotonInteraction(gas, beam);
    tW = tV.*denom;
    
    eff_Hg = -tV'*tW;  eff_He = tV*tW';
%     shift_g = real(eff_Hg); gamma_g = -imag(eff_Hg);
%     shift_e = real(eff_He); gamma_e = -imag(eff_He);
    shift_g = 0.5*(eff_Hg+eff_Hg'); gamma_g = 1i*(eff_Hg-eff_Hg');
    shift_e = 0.5*(eff_He+eff_He'); gamma_e = 1i*(eff_He-eff_He');
    pump_rate_g = trace(gamma_g)/dimG;
    pump_rate_e = trace(gamma_e)/dimE;
    
    A_pump_gg = 1i*circleC(eff_Hg)/pump_rate_g;
    A_pump_ee = 1i*circleC(eff_He)/pump_rate_e;
    A_pump_ge = -1i*( kron(tW.', tV') - kron(tV.', tW') )/pump_rate_e;
    A_pump_eg = -1i*( kron(conj(tV), tW) - kron(conj(tW), tV) )/pump_rate_g;
    
    A_collision_gg = zeros(dimG*dimG);
    A_collision_ee = zeros(dimE*dimE);
    A_collision_ge = zeros(dimG*dimG, dimE*dimE);
    A_collision_eg = zeros(dimE*dimE, dimG*dimG);

    gamma_s_ge = gas.atom.parameters.gamma_s(Dk);
    A_spDecay_ge=gas.atom.operator.spDecay{Dk};
    
    
    freq = gas.atom.eigen.transFreq;
    gamma1 = gamma_s_ge;
    gamma2 = gas.gamma2+0.5*gamma_s_ge;
    E_ee = diag( freq{1+Dk, 1+Dk}(:) - 1i*gamma1 );
    %E_ge = diag( freq{1, 1+Dk}(:) - 1i*gamma2 );
    %E_eg = diag( freq{1+Dk, 1}(:) - 1i*gamma2 );
    E_gg = diag( freq{1, 1}(:) );
    
    qsG_ee =1i*E_ee + 0*pump_rate_e*A_pump_ee + A_collision_ee;
    qsG_ge =-gamma_s_ge*A_spDecay_ge - 0*pump_rate_e*A_pump_ge + A_collision_ge;
    qsG_eg =-0*pump_rate_g*A_pump_eg;
    qsG_gg = 1i*E_gg + pump_rate_g*A_pump_gg + A_collision_gg;
    qsG = [qsG_ee qsG_eg; qsG_ge qsG_gg];
    
    
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
    
    optical_matrix.E_ee = E_ee;
    optical_matrix.E_gg = E_gg;

    optical_matrix.qsG_ee = qsG_ee;
    optical_matrix.qsG_eg = qsG_eg;
    optical_matrix.qsG_ge = qsG_ge;
    optical_matrix.qsG_gg = qsG_gg;
    optical_matrix.qsG = qsG;

end

