classdef GasGasInteraction < Interaction.AbstractInteraction
    %GASGASINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = GasGasInteraction(gas1, gas2)
            obj@Interaction.AbstractInteraction(gas1, gas2);
        end
    end
    
end

