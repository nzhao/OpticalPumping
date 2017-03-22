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
              [sd_mat, sd_rate]=Interaction.SDampingMat(obj.vapor, obj.buffer);
              mat = sd_mat{1};  obj.parameter.sd_rate=sd_rate{1};
        end

    end
    
end

