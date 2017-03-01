function gsG = matrix_ground_state( obj )
%MATRIX_GROUND_STATE Summary of this function goes here
%   Detailed explanation goes here
    Dk = obj.beam.refTransition; % D1 or D2
    dimG = obj.vapor.atom.dim(1);
    dimE = obj.vapor.atom.dim(1+Dk);
    
    obj.matrix_effective_Hamiltonian();
    
    tV = obj.matrix.tV; tW = obj.matrix.tW;
    eff_Hg = obj.matrix.eff_Hg;  eff_He = obj.matrix.eff_He;
    pump_rate_g = obj.parameter.pump_rate_g; pump_rate_e = obj.parameter.pump_rate_e; 
    
    A_pump_gg = 1i*circleC(eff_Hg)/pump_rate_g;
    A_pump_ee = 1i*circleC(eff_He)/pump_rate_e;
    A_pump_ge = -1i*( kron(tW.', tV') - kron(tV.', tW') )/pump_rate_e;
    A_pump_eg = -1i*( kron(conj(tV), tW) - kron(conj(tW), tV) )/pump_rate_g;

    A_collision_gg = zeros(dimG*dimG);
    A_collision_ee = zeros(dimE*dimE);
    A_collision_ge = zeros(dimG*dimG, dimE*dimE);

    gamma_s_ge = obj.vapor.atom.parameters.gamma_s(Dk);
    A_spDecay_ge=obj.vapor.atom.operator.spDecay{Dk};


    freq = obj.vapor.atom.eigen.transFreq;
    gamma1 = gamma_s_ge;
    E_ee = diag( freq{1+Dk, 1+Dk}(:) - 1i*gamma1 );
    E_gg = diag( freq{1, 1}(:) );

    qsG_ee =1i*E_ee + pump_rate_e*A_pump_ee + A_collision_ee;
    qsG_ge =-gamma_s_ge*A_spDecay_ge - pump_rate_e*A_pump_ge + A_collision_ge;
    qsG_eg =-pump_rate_g*A_pump_eg;
    qsG_gg = 1i*E_gg + pump_rate_g*A_pump_gg + A_collision_gg;
    gsG = qsG_gg - qsG_ge*(qsG_ee\qsG_eg);

    
    %% output variables
    %obj.matrix.vapor_kernel = gsG;
end

