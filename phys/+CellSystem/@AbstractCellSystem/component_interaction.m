function interaction = component_interaction( obj, k, q )
%MAKE_INTERACTION Summary of this function goes here
%   Detailed explanation goes here
    comp_k = obj.component{k};
    comp_q = obj.component{q};

    type_pair = [comp_k.stuff.type, '-', comp_q.stuff.type];
    switch type_pair 
        case 'vapor-beam'
            interaction = Interaction.GasBeamInteraction(comp_k, comp_q);
        case 'beam-vapor'
            interaction = Interaction.GasBeamInteraction(comp_q, comp_k);
        case 'vapor-vapor'
            interaction = Interaction.GasGasInteraction(comp_k, comp_q);
        otherwise
            interaction = Interaction.EmptyInteraction(comp_k, comp_q);
            warning('non-supported types %s', type_pair);
    end

end

