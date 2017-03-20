function [tV, tW] = matrix_effective_Hamiltonian( obj )
%MATRIX_EFFECTIVE_HAMILTONIAN Summary of this function goes here
%   Detailed explanation goes here

    Dk = obj.beam.refTransition; % D1 or D2
    dimG = obj.vapor.atom.dim(1);
    dimE = obj.vapor.atom.dim(1+Dk);
    
    switch obj.option
        case 'high-pressure'
            denom = Interaction.DenominatorMat(obj.vapor, obj.beam, 'HighPressure');
        otherwise
            denom = Interaction.DenominatorMat(obj.vapor, obj.beam, obj.parameter.velocity);
    end
    tV =  Interaction.AtomPhotonInteraction(obj.vapor, obj.beam);
    tW = tV.*denom;

    Hg = -tV'*tW;  He = tV*tW';
    shift_g = 0.5*(Hg+Hg'); gamma_g = 1i*(Hg-Hg');
    shift_e = 0.5*(He+He'); gamma_e = 1i*(He-He');
    pump_rate_g = trace(gamma_g)/dimG;
    pump_rate_e = trace(gamma_e)/dimE;
    kappa = trace(shift_g)/pump_rate_g;

    mat_ge = zeros(dimG, dimE); mat_eg=zeros(dimE, dimG);
    gamma_col = [gamma_e(:); mat_eg(:); mat_ge(:); gamma_g(:)];

    obj.matrix.tV = tV;
    obj.matrix.tW = tW;
    obj.matrix.eff_Hg = Hg;
    obj.matrix.eff_He = He;
    obj.matrix.shift_e = shift_e;
    obj.matrix.shift_g = shift_g;
    obj.matrix.gamma_e = gamma_e;
    obj.matrix.gamma_g = gamma_g;
    obj.matrix.gamma_col = gamma_col;

    obj.parameter.dimG = dimG;
    obj.parameter.dimE = dimE;
    obj.parameter.pump_rate_g = pump_rate_g;
    obj.parameter.pump_rate_e = pump_rate_e;
    obj.parameter.kappa = kappa;

end

