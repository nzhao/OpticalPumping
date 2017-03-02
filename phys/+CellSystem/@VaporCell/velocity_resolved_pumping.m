function data = velocity_resolved_pumping(obj, beam_idx, vapor_idx, t_pump)  
%VELOCITY_RESOLVED_PUMPING Summary of this function goes here
%   Detailed explanation goes here
        
    [len, data.vList, data.uList, data.wList, data.sigmaV] = ...
        obj.interaction{beam_idx, vapor_idx}.velocity_sampling();

    state=cell(1, len); gammaG=cell(1, len);
    for k=1:len
        obj.interaction{beam_idx, vapor_idx}.set_velocity( data.vList(k) ).calc_matrix(); 
        state{k} = obj.evolution(vapor_idx, t_pump);
        gammaG{k} = obj.interaction{1, vapor_idx}.matrix.gamma_g;
    end

    stateG           = cellfun(@(s) s.block(2,2), state, 'UniformOutput', false);            
    data.stateG      = cell2mat(cellfun(@(s) s(:),    stateG, 'UniformOutput', false));
    data.popG        = cell2mat(cellfun(@(s) diag(s), stateG, 'UniformOutput', false));
    data.gammaG      = cell2mat(cellfun(@(s) s(:),    gammaG, 'UniformOutput', false));
    data.gammaG_diag = cell2mat(cellfun(@(s) diag(s), gammaG, 'UniformOutput', false));
    data.absorption  =dot( conj(data.stateG), data.gammaG);
end

