classdef Noble < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        parameters
        hasSpin = 1
        
        K
        Kmat
        dim
        
        rho
    end
    
    methods
        function obj = Noble(name)
            obj.name = name;
            obj.parameters = Atom.AtomParameters(name);
            
            obj.K = obj.parameters.spin_K;
            obj.Kmat = Atom.Spin(obj.K);
            
            obj.dim = 2*obj.K + 1;
            obj.rho = Algorithm.DensityMatrix(obj);
        end
        
        function K = mean_spin(obj, rho)
            K = rho.mean(obj.Kmat);
        end
        
    end
    
end

