function interaction = component_interaction( obj, k, q )
%MAKE_INTERACTION Summary of this function goes here
%   Detailed explanation goes here
    comp_k = obj.component{k};
    comp_q = obj.component{q};

    freq_diff = abs(comp_k.frequency - comp_q.frequency);
%     if freq_diff > MAX_FREQ_DIFF
%         interaction = Interaction.EmptyInteraction(comp_k, comp_q);
%     else
    type_pair = [comp_k.stuff.type, '-', comp_q.stuff.type];
    switch type_pair 
        case {'vapor-beam', 'beam-vapor'}
            if freq_diff > MAX_FREQ_DIFF
                interaction = Interaction.EmptyInteraction(comp_k, comp_q);
            else
                interaction = Interaction.VaporBeamInteraction(comp_k, comp_q);
            end
        case 'vapor-vapor'
            interaction = Interaction.VaporVaporInteraction(comp_k, comp_q);
        case {'vapor-buffer', 'buffer-vapor'}
            interaction = Interaction.VaporBufferInteraction(comp_k, comp_q);
        otherwise
            interaction = Interaction.EmptyInteraction(comp_k, comp_q);
    end
%     end

end

