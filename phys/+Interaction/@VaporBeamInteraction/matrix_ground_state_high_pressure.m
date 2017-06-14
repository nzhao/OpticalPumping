function mat = matrix_ground_state_high_pressure( obj )
%MATRIX_GROUND_STATE_HIGH_PRESSURE Summary of this function goes here
%   Detailed explanation goes here

    obj.matrix_effective_Hamiltonian();
    
    atom = obj.vapor.atom;
    mat_h0 = circleC(atom.eigen.eigen_system{1}.diag_H ... 
                   + atom.matEigen.zeeman_terms(:,:,1) ...
                   + atom.matEigen.zeeman_terms(:,:,2));
    mat_sd = atom.operator.SD;
    mat_se = atom.operator.SE;
    
    beam = obj.beam;
    spinK = beam.fictionSpin;

    gamma_p = obj.parameter.pump_rate_g;
    kappa = obj.parameter.kappa;
    
    Sc = atom.operator.S_circleC;
    KdotSc = spinK(1)*Sc(:, :, 1) + spinK(2)*Sc(:, :, 2) + spinK(3)*Sc(:, :, 3);
    
    mat = gamma_p*( mat_sd ...
                  - spinK(1)*mat_se(:,:,1) ...
                  - spinK(2)*mat_se(:,:,2) ...
                  - spinK(3)*mat_se(:,:,3) ...
                  - 2.0*1j*kappa*KdotSc );

    mat = mat + 1j*mat_h0;
end

