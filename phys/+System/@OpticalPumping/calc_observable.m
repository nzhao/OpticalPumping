function obs = calc_observable( obj )
%CALC_OBSERVABLE Summary of this function goes here
%   Detailed explanation goes here
    idx = 1;
    atom = obj.get_atom(idx);
    
    obs = zeros(3, length(obj.result.time));
    for k=1:length(obs)
        state = obj.result.state{k}{idx};
        obs(:, k) = atom.mean_spin(state);
    end
    obj.result.observable = obs;

end

