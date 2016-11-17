function sr_term = calc_sr_term( obj, k, state )
%CAL_SR_TERM Summary of this function goes here
%   Detailed explanation goes here
    gas = obj.gasList{k};
    switch gas.type
        case 'vapor'
            dim = gas.atom.dim(1);
            sr_term = zeros( dim*dim ) ;

            sr_op = gas.atom.operator.S_circleC;
            for q = 1:length(obj.gasList)
                if obj.gasList{q}.atom.hasSpin
                    c_kq = obj.spin_rotation(k, q) ;
                    v_q = obj.gasList{q}.atom.mean_spin( state{q} );
                    sr_term = sr_term + v_dot_m( c_kq, v_q, sr_op);
                end
            end
        case 'noble'
            sr_term = 7;
        otherwise
            sr_term = [];
    end

end

