function set_component_parameter( obj, k )
%COMPONENT_INTERACTION_PARAMETER Summary of this function goes here
%   Detailed explanation goes here
    comp = obj.component{k};
    if strcmp(comp.type, 'vapor')
        buf = obj.component(obj.get_buffer_index);
        
        gamma2 = 0.0;
        for k=1:length(buf)
            gamma2 = gamma2 + Interaction.PressureBroadening(comp.stuff, buf{k}.stuff);
        end
        comp.stuff.gamma2=gamma2;
    end
end

