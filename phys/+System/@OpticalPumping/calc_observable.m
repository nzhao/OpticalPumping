function obs = calc_observable( obj )
%CALC_OBSERVABLE Summary of this function goes here
%   Detailed explanation goes here
    idx = 1;
    atom = obj.get_atom(idx);
    
    ntime = length(obj.result.time);
    obs.mean_spin = zeros(3, ntime);
    obs.population = zeros(atom.dim(1), ntime);
    obs.abs_cross_section = zeros(1, ntime);
    for k=1:ntime
        state = obj.result.state{k}{idx};
        obs.mean_spin(:, k) = atom.mean_spin(state);
        obs.population(:, k) = diag(state.mat);
        obs.abs_cross_section(:,k) = ...
            obj.result.state{k}{idx}.mean(obj.gases.optical_pumping{idx}.effective_Gamma) * 2*pi*1e6 ...
            / obj.beam.photonFlux * 1e4;
    end
    obj.result.observable = obs;

end

