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
            if nargin < 4
                nB = 101;
            end
            
            obj.iter = iterator( num2cell(linspace(minB,maxB,nB)) );
            obj.type='sweep';
        end
        
        function obj = move_forward(obj)
            obj.iter.next;
        end
        
        function obj = restart(obj)
            obj.iter.reset();
        end
        
        function obj = restart0(obj)
            obj.iter.reset0();
        end
        
    end
    
end

