function parameter = component_interaction_parameter( obj, k )
%COMPONENT_INTERACTION_PARAMETER Summary of this function goes here
%   Detailed explanation goes here
    comp = obj.component{k};
    parameter.name = comp.name;
    if strcmp(comp.type, 'vapor')
        buf = obj.component(obj.get_buffer_index);
        
        parameter.pressure_broadening = 0.0;
        for k=1:length(buf)
            parameter.pressure_broadening = parameter.pressure_broadening + ...
                                            calc_pressure_boradening(comp.stuff, buf{k}.stuff);
        end
    end
end

