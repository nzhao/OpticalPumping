classdef GasBeamInteraction < Interaction.AbstractInteraction
    %GASBEAMINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = GasBeamInteraction(gas, beam)
            obj@Interaction.AbstractInteraction(gas, beam);        
        end
    end
    
end

