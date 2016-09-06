classdef AlkaliMetal < handle
    %ALKALIMETAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        parameters
        
        I
        S = 0.5
        
        a
        b
        
        J=[0.5, 0.5, 1.5]
        
        gI
        gJ
        
        dim
        
        mat
    end
    
    methods
        function obj = AlkaliMetal(name)
            obj.name = name;
            obj.parameters = Atom.AtomParameters(name);
            
            obj.I = obj.parameters.spin_I; 
            obj.a = obj.I-0.5; obj.b = obj.I + 0.5;
            
            obj.gI = 2*obj.I+1;  
            obj.gJ = 2*obj.J+1;
            obj.dim = obj.gI * obj.gJ;
            
            obj.mat = obj.spinMatrix();
        end
    end
    
end

