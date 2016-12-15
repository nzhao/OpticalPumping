classdef VaporVaporInteraction < Interaction.AbstractInteraction
    %GASGASINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = VaporVaporInteraction(gas1, gas2)
            obj@Interaction.AbstractInteraction(gas1, gas2);
        end
        
        function obj = calc_matrix(obj)
            switch obj.type
                case 'self'
                    obj.matrix.kernel1 = 0.0;
                    obj.matrix.kernel={obj.matrix.kernel1};
                case 'mutual'
                    obj.matrix.kernel1 = 0.0;
                    obj.matrix.kernel2 = 0.0;
                    obj.matrix.kernel12 = 0.0;
                    obj.matrix.kernel={obj.matrix.kernel1, ...
                                       obj.matrix.kernel2, ...
                                       obj.matrix.kernel12};
            end
        end

    end
    
end

