function res = calc_obs( density_matrix, obs )
%CALC_OBS Summary of this function goes here
%   Detailed explanation goes here
    res = containers.Map();
    keys = obs.keys();
    vals = obs.values();
    for k =1:length(keys)
        op_k = vals{k};
        
        nstate = length(density_matrix);
        mean_val = zeros(1, nstate);
        for q = 1:nstate
            mean_val(q) = density_matrix{q}.mean(op_k);
        end
        res( keys{k} ) = mean_val;
    end

end

