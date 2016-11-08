classdef VaporVaporInteraction < Interaction.AbstractInteraction
    %GASGASINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = VaporVaporInteraction(gas1, gas2)
            obj@Interaction.AbstractInteraction(gas1, gas2);
        end
        
        function calc_matrix(obj)
        end

    end
    
end

