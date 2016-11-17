classdef EmptyInteraction < Interaction.AbstractInteraction
    %EMPTYINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = EmptyInteraction(comp1, comp2)
            obj@Interaction.AbstractInteraction(comp1, comp2);
        end
        
        function calc_matrix(obj)
        end
    end
    
end

