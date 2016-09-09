classdef Coil < handle
    %COIL Summary of this class goes here
    %   Detailed explanation goes here
%     enumeration
%         FIXED (0)
%         SWEEP (1)
%     end
    properties
        name
        type
        magB
        
        iter
    end
    
    methods
        function obj=Coil(name)
            obj.name = name;
        end
        
        function obj = set_magB(obj, magB)
            obj.magB=magB;
            obj.type='fixed';
        end
        
        function magB = get_magB(obj)
            switch obj.type
                case 'fixed'
                    magB = obj.magB;
                case 'sweep'
                    magB = obj.iter.current();
            end
        end
        
        function obj = sweep_mag(obj, minB, maxB, nB)            
            obj.iter = iterator( num2cell(linspace(minB,maxB,nB)) );
            obj.type='sweep';
        end
        
    end
    
end

