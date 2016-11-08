function matrix_steady_state( obj )
%MATRIX_STEADY_STATE Summary of this function goes here
%   Detailed explanation goes here
    Dk = obj.beam.refTransition; % D1 or D2
    dimG = obj.vapor.atom.dim(1);
    dimE = obj.vapor.atom.dim(1+Dk);
    
    velocity_list = obj.parameter.velocityList; nVelocity = length(velocity_list);
    qsG_ee = cell(1, nVelocity); qsG_eg = cell(1, nVelocity);
    qsG_ge = cell(1, nVelocity); qsG_gg = cell(1, nVelocity);
    qsG = cell(1, nVelocity);
    
    eff_Hg = cell(1, nVelocity); eff_He = cell(1, nVelocity);
    shift_g = cell(1, nVelocity); shift_e = cell(1, nVelocity);
    gamma_g = cell(1, nVelocity); gamma_e = cell(1, nVelocity);
    pump_rate_g = zeros(1, nVelocity); pump_rate_e = zeros(1, nVelocity);
    
    A_pump_ee = cell(1, nVelocity); A_pump_eg = cell(1, nVelocity);
    A_pump_ge = cell(1, nVelocity); A_pump_gg = cell(1, nVelocity);
    
    for k=1:nVelocity
        %denom = Interaction.DenominatorMat(obj.vapor, obj.beam, 'DopplerAverage');
        denom = Interaction.DenominatorMat(obj.vapor, obj.beam, velocity_list(k));
        tV =  Interaction.AtomPhotonInteraction(obj.vapor, obj.beam);
        tW = tV.*denom;

        eff_Hg{k} = -tV'*tW;  eff_He{k} = tV*tW';
        shift_g{k} = 0.5*(eff_Hg{k}+eff_Hg{k}'); gamma_g{k} = 1i*(eff_Hg{k}-eff_Hg{k}');
        shift_e{k} = 0.5*(eff_He{k}+eff_He{k}'); gamma_e{k} = 1i*(eff_He{k}-eff_He{k}');
        pump_rate_g(k) = trace(gamma_g{k})/dimG;
        pump_rate_e(k) = trace(gamma_e{k})/dimE;

        A_pump_gg{k} = 1i*circleC(eff_Hg{k})/pump_rate_g(k);
        A_pump_ee{k} = 1i*circleC(eff_He{k})/pump_rate_e(k);
        A_pump_ge{k} = -1i*( kron(tW.', tV') - kron(tV.', tW') )/pump_rate_e(k);
        A_pump_eg{k} = -1i*( kron(conj(tV), tW) - kron(conj(tW), tV) )/pump_rate_g(k);

        A_collision_gg = zeros(dimG*dimG);
        A_collision_ee = zeros(dimE*dimE);
        A_collision_ge = zeros(dimG*dimG, dimE*dimE);
        %A_collision_eg = zeros(dimE*dimE, dimG*dimG);

        gamma_s_ge = obj.vapor.atom.parameters.gamma_s(Dk);
        A_spDecay_ge=obj.vapor.atom.operator.spDecay{Dk};


        freq = obj.vapor.atom.eigen.transFreq;
        gamma1 = gamma_s_ge;
        %gamma2 = obj.vapor.gamma2+0.5*gamma_s_ge;
        E_ee = diag( freq{1+Dk, 1+Dk}(:) - 1i*gamma1 );
        %E_ge = diag( freq{1, 1+Dk}(:) - 1i*gamma2 );
        %E_eg = diag( freq{1+Dk, 1}(:) - 1i*gamma2 );
        E_gg = diag( freq{1, 1}(:) );

        qsG_ee{k} =1i*E_ee + pump_rate_e(k)*A_pump_ee{k} + A_collision_ee;
        qsG_ge{k} =-gamma_s_ge*A_spDecay_ge - pump_rate_e(k)*A_pump_ge{k} + A_collision_ge;
        qsG_eg{k} =-pump_rate_g(k)*A_pump_eg{k};
        qsG_gg{k} = 1i*E_gg + pump_rate_g(k)*A_pump_gg{k} + A_collision_gg;
        qsG{k} = [qsG_ee{k} qsG_eg{k}; qsG_ge{k} qsG_gg{k}];
    end
    
    %% output variables
    obj.matrix.qsG_ee = qsG_ee;
    obj.matrix.qsG_ge = qsG_ge;
    obj.matrix.qsG_eg = qsG_eg;
    obj.matrix.qsG_gg = qsG_gg;
    obj.matrix.qsG = qsG;
    obj.matrix.shift_e = shift_e;
    obj.matrix.shift_g = shift_g;
    obj.matrix.gamma_e = gamma_e;
    obj.matrix.gamma_g = gamma_g;
    
    obj.parameter.dimG = dimG;
    obj.parameter.dimE = dimE;
    obj.parameter.pump_rate_g = pump_rate_g;
    obj.parameter.pump_rate_e = pump_rate_e;
end

