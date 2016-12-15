classdef EmptyInteraction < Interaction.AbstractInteraction
    %EMPTYINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = EmptyInteraction(comp1, comp2)
            obj@Interaction.AbstractInteraction(comp1, comp2);
        end
        
        function obj = calc_matrix(obj)
            obj.matrix.kernel1 = 0.0;
            obj.matrix.kernel2 = 0.0;
            obj.matrix.kernel12 = 0.0;
            obj.matrix.kernel={obj.matrix.kernel1, ...
                               obj.matrix.kernel2, ...
                               obj.matrix.kernel12};
        end
    end
    
end

