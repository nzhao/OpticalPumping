classdef Nitrogen
    %NIGROGEN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        hasSpin = 0
        
        rho = []
    end
    
    methods
        function obj = Nitrogen()
            obj.name = 'nitrogen';
        end
        
        function s = mean_spin(obj, rho)
            s = [0 0 0];
        end
    end
    
end

