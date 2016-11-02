function op_term = calc_op_term( obj, k )
%CALC_OP_TERM Summary of this function goes here
%   Detailed explanation goes here

    gas = obj.gasList{k};
    op_term = [];
    if isfield(obj.optical_pumping{k}, 'gamma_p')
        sd_op = gas.atom.operator.SD;
        se_op = gas.atom.operator.SE;
        coeff = obj.optical_pumping{k}.gamma_p;
        v = obj.optical_pumping{k}.photon_spin;
        op_term = coeff*sd_op - v_dot_m(coeff, v, se_op);
    end
end

