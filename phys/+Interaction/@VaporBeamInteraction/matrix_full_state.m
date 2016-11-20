function matrix_full_state( obj )
%MATRIX_FULL_STATE Summary of this function goes here
%   Detailed explanation goes here
    Dk = obj.beam.refTransition; % D1 or D2
    dimG = obj.vapor.atom.dim(1);
    dimE = obj.vapor.atom.dim(1+Dk);
    
        denom = Interaction.DenominatorMat(obj.vapor, obj.beam, obj.parameter.velocity);
        tV =  Interaction.AtomPhotonInteraction(obj.vapor, obj.beam);
        tW = tV.*denom;

        eff_Hg = -tV'*tW;  eff_He = tV*tW';
        shift_g = 0.5*(eff_Hg+eff_Hg'); gamma_g = 1i*(eff_Hg-eff_Hg');
        shift_e = 0.5*(eff_He+eff_He'); gamma_e = 1i*(eff_He-eff_He');
        pump_rate_g = trace(gamma_g)/dimG;
        pump_rate_e = trace(gamma_e)/dimE;
        
        mat_ge = zeros(dimG, dimE); mat_eg=zeros(dimE, dimG);
        gamma_col = [gamma_e(:); mat_eg(:); mat_ge(:); gamma_g(:)];

        A_pump_gg = 1i*circleC(eff_Hg)/pump_rate_g;
        A_pump_ee = 1i*circleC(eff_He)/pump_rate_e;
        A_pump_ge = -1i*( kron(tW.', tV') - kron(tV.', tW') )/pump_rate_e;
        A_pump_eg = -1i*( kron(conj(tV), tW) - kron(conj(tW), tV) )/pump_rate_g;

        A_collision_gg = zeros(dimG*dimG);
        A_collision_ee = zeros(dimE*dimE);
        A_collision_ge = zeros(dimG*dimG, dimE*dimE);
        %A_collision_eg = zeros(dimE*dimE, dimG*dimG);

        gamma_s_ge = obj.vapor.atom.parameters.gamma_s(Dk);
        A_spDecay_ge=obj.vapor.atom.operator.spDecay{Dk};


        freq = obj.vapor.atom.eigen.transFreq;
        gamma1 = gamma_s_ge;
        gamma2 = obj.vapor.gamma2+0.5*gamma_s_ge;
        E_ee = diag( freq{1+Dk, 1+Dk}(:) - 1i*gamma1 );
        E_ge = diag( freq{1, 1+Dk}(:) - 1i*gamma2 );
        E_eg = diag( freq{1+Dk, 1}(:) - 1i*gamma2 );
        E_gg = diag( freq{1, 1}(:) );

        qsG_ee =1i*E_ee + pump_rate_e*A_pump_ee + A_collision_ee;
        qsG_ge =-gamma_s_ge*A_spDecay_ge - pump_rate_e*A_pump_ge + A_collision_ge;
        qsG_eg =-pump_rate_g*A_pump_eg;
        qsG_gg = 1i*E_gg + pump_rate_g*A_pump_gg + A_collision_gg;
        qsG = [qsG_ee qsG_eg; qsG_ge qsG_gg];

        Pg=obj.vapor.atom.operator.Proj{1}; Pe=obj.vapor.atom.operator.Proj{1+Dk};
        gg=obj.vapor.atom.dim(1); ge=obj.vapor.atom.dim(1+Dk);
        n1=1:ge^2; n2=ge^2+1:ge^2+ge*gg; n3=ge^2+ge*gg+1:ge^2+2*ge*gg; n4=ge^2+2*ge*gg+1:(ge+gg)^2; 

        G0=zeros((ge+gg)^2); 
        G0(n1, n1)=1i*E_ee; G0(n2, n2)=1i*E_ge; G0(n3, n3)=1i*E_eg; G0(n4, n4)=1i*E_gg;

        G1=zeros((ge+gg)^2); 
        G1(n1, n2)=1i*kron(Pe, tV); 
        G1(n1, n3)=-1i*kron(conj(tV), Pe);
        G1(n2, n4)=-1i*kron(conj(tV), Pg);
        G1(n3, n4)=1i*kron(Pg, tV);
        G1=G1-G1';

        G2=zeros((ge+gg)^2);
        G2(n4, n1)=-gamma_s_ge*A_spDecay_ge;

        G3=zeros((ge+gg)^2);

        detune = obj.get_atom_beam_detuning();
        doppler_shif = obj.beam.wavenumber*obj.parameter.velocity /2/pi *1e-6;
        G3(n2, n2)=1i*(detune-doppler_shif)*eye(ge*gg);
        G3(n3, n3)=-1i*(detune-doppler_shif)*eye(ge*gg);

        fullG=G0+G1+G2+G3;
    
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
    
    obj.matrix.fullG = fullG;
    obj.matrix.gamma_col = gamma_col;
    
    obj.parameter.dimG = dimG;
    obj.parameter.dimE = dimE;
    obj.parameter.pump_rate_g = pump_rate_g;
    obj.parameter.pump_rate_e = pump_rate_e;
end

