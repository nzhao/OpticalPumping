function operator = RelaxationS( S_op, freq_shift, S_damping_rate, S_exchange_rate, exchange_vector )
%RELAXATIONS Summary of this function goes here
%   Detailed explanation goes here
    operator.sd =   S_damping_rate  * SDmat(S_op); % spin-damping operator: propto \varphi-\rho
    operator.ex = - S_exchange_rate * SEmat(S_op, exchange_vector); % spin-exchange operator: v \dot \mathbf{S} \varphi
    operator.sf =     1i*freq_shift * SRmat(S_op, exchange_vector); % spin-frequency-shift (or rotation) operator: commutator [ . , v \dot \mathbf{S} ]
end

