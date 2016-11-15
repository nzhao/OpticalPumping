function sd_term = calc_sd_term( obj, k )
%CALC_KERNEL Summary of this function goes here
%   Detailed explanation goes here
    gas = obj.gasList{k};
    switch gas.type
        case 'vapor'
            dim = gas.atom.dim(1);
            sd_term = zeros( dim*dim ) ;

            sd_op = gas.atom.operator.SD;
            for q = 1:length(obj.gasList)
                c_kq = obj.spin_destruction(k, q);
                sd_term = sd_term +  c_kq * sd_op;
            end
        case 'noble'
            sd_term = 3;
        otherwise
            sd_term = [];
    end
end

