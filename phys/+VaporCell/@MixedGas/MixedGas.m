classdef MixedGas < handle
    %MIXEDGAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gasList
        
        spin_destruction
        spin_exchange
        spin_rotation

        optical_pumping
    end
    
    methods
        function obj = MixedGas(gas)
            obj.gasList = gas;
            
            obj.set_pressure_broadening();
            obj.set_collision_rate();
            
        end

    end
    
end

