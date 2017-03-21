classdef VaporBufferInteraction  < Interaction.AbstractInteraction
    %VaporBufferInteraction Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vapor
        buffer
        typeStr
    end
    
    methods
        function obj = VaporBufferInteraction(comp1, comp2)
            obj@Interaction.AbstractInteraction(comp1, comp2);

            obj.typeStr = [comp1.stuff.type, '-', comp2.stuff.type];
            switch obj.typeStr 
            case 'vapor-buffer'
                obj.vapor = comp1.stuff;
                obj.buffer = comp2.stuff;
                obj.option = comp1.option;
            case 'buffer-vapor'
                obj.buffer = comp1.stuff;
                obj.vapor = comp2.stuff;
                obj.option = comp2.option;
            end
            
        end
        
        function obj = calc_matrix(obj)
            obj.matrix.kernel={0.0, 0.0, 0.0};
            switch obj.typeStr  
                case 'vapor-buffer'
                    obj.matrix.kernel{1} = obj.vapor_matrix();
                case 'buffer-vapor'
                    obj.matrix.kernel{2} = obj.vapor_matrix();
            end

        end

        function mat = vapor_matrix(obj)
            sd_mat = obj.vapor.atom.operator.SD;
            sd_cross_section = obj.sd_crosssection(obj.vapor.name, ...
                                                   obj.buffer.name);
            sd_rate = obj.buffer.density*1e-6 ... % m-3 to cm-3
                    * sd_cross_section ...        % cm2
                    * obj.buffer.velocity*1e2 ... % m/s to cm/s;
                    * 1e-6;                       % s-1 to 2pi*MHz;
            mat = sd_rate * sd_mat;
            
            obj.parameter.sd_rate=sd_rate;
        end

    end
    
end

