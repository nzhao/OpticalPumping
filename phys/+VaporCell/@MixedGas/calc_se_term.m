function se_term = calc_se_term( obj, k, state)
%CALC_SE_TERM Summary of this function goes here
%   Detailed explanation goes here

    gas = obj.gasList{k};
    switch gas.type
        case 'vapor'
            dim = gas.atom.dim(1);
            se_term = zeros( dim*dim ) ;

            sd_op = gas.atom.operator.SD;
            se_op = gas.atom.operator.SE;
            for q = 1:length(obj.gasList)
                if obj.gasList{q}.atom.hasSpin
                    c_kq = obj.spin_exchange(k, q);
                    v_q = obj.gasList{q}.atom.mean_spin( state{q} );
                    se_term = se_term + c_kq*sd_op - v_dot_m(c_kq, v_q, se_op);
                end
            end
        case 'noble'
            se_term = 5;
        otherwise
            se_term = [];
    end
end

