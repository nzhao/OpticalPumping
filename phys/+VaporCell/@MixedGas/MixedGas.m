classdef MixedGas < handle
    %MIXEDGAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gasList
        
        sd_coeff
        se_coeff
    end
    
    methods
        function obj = MixedGas(gas)
            obj.gasList = gas;
            nGas = length(gas);
            
            obj.sd_coeff = zeros(nGas);
            obj.se_coeff = zeros(nGas);
            
            for k=1:nGas
                for q=1:nGas
                    obj.sd_coeff(k,q) = obj.SDRatio(gas{k}, gas{q});
                    obj.se_coeff(k,q) = obj.SERatio(gas{k}, gas{q});
                end
            end
            
        end
    end
    
    methods (Access=private)
        r=SDRatio(obj, gas1, gas2)
        r=SERatio(obj, gas1, gas2)
    end
    
end

