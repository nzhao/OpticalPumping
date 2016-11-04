classdef AbstractCellSystem < handle
    %ABSTRACTCELLSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gas
        beam
        ingredient
        interaction
    end
    
    methods
        function obj = AbstractCellSystem(gas, beam)
            if iscell(gas)
                obj.gas = gas;
            else
                obj.gas =  {gas};
            end
            
            if iscell(beam)
                obj.beam = beam;
            else
                obj.beam = {beam};
            end
            
            obj.ingredient = [obj.beam, obj.gas];
            
            nIngredient = length(obj.ingredient);
            obj.interaction = cell(nIngredient);
        end
        
        function obj = calc_interaction(obj)
            for k = 1:length(obj.ingredient)
                for q = 1:length(obj.ingredient)
                    obj.interaction{k, q} = calc
                end
            end
        end
    end
    
end

