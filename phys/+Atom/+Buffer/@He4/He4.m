classdef He4
    %HE4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        hasSpin = 0
        parameters
        
        rho = []
    end
    
    methods
        function obj = He4()
            obj.name = '4He';
            obj.parameters = Atom.AtomParameters(obj.name);
        end

        function s = mean_spin(obj, rho)
            s = [0 0 0];
        end
    end
    
end

