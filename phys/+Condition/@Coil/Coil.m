classdef Coil < handle
    %COIL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        magB
    end
    
    methods
        function obj=Coil(name)
            obj.name = name;
        end
        
        function set_magB(obj, magB)
            obj.magB=magB;
        end
    end
    
end

