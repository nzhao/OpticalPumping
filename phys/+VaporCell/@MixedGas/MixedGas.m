classdef MixedGas < handle
    %MIXEDGAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gasList
        nGas
        
        spin_destruction
        spin_exchange
        spin_rotation

        optical_pumping
    end
    
    methods
        function obj = MixedGas(gas)
            obj.gasList = gas;
            obj.nGas = length(obj.gasList);
            
            obj.set_pressure_broadening();
            obj.set_collision_rate();

        end
        
        function set_pressure_broadening( obj )
            for k=1:obj.nGas
                obj.gasList{k}.pressureBroadening(obj.gasList);
            end
        end
        
        
        function set_collision_rate( obj )
            obj.spin_destruction = zeros(obj.nGas);
            obj.spin_exchange = zeros(obj.nGas);
            obj.spin_rotation = zeros(obj.nGas);

            for k=1:obj.nGas
                for q=1:obj.nGas
                    obj.spin_destruction(k,q) = obj.SDRate(obj.gasList{k}, obj.gasList{q});
                    obj.spin_exchange(k,q) = obj.SERate(obj.gasList{k}, obj.gasList{q});
                    obj.spin_rotation(k,q) = obj.SRRate(obj.gasList{k}, obj.gasList{q});
                end
            end

        end

        function set_pumping_rate( obj, beam )
            obj.optical_pumping = cell(size(obj.gasList));
            for k=1:obj.nGas
                gas_k = obj.gasList{k};
                if strcmp(gas_k.type, 'vapor')
                    obj.optical_pumping{k} = gas_k.highPressurePumping(beam);
                end
            end

        end

    end
    
end

