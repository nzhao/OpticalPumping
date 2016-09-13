function obs = calc_observable( obj )
%CALC_OBSERVABLE Summary of this function goes here
%   Detailed explanation goes here
    idx = 1;
    atom = obj.get_atom(idx);
    
     obs.mean_spin = zeros(3, length(obj.result.time));
     obs.population = zeros(atom.dim(1), length(obj.result.time));
    for k=1:length(obj.result.time)
        state = obj.result.state{k}{idx};
        obs.mean_spin(:, k) = atom.mean_spin(state);
        obs.population(:, k) = diag(state.mat);
    end
    obj.result.observable = obs;

end

