classdef Component < handle
    %COMPONENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        index
        name
        type
        stuff
        state
        option
    end
    
    methods
        function obj = Component(idx, stuff, state, option)
            obj.index = idx;
            obj.stuff = stuff;
            obj.name = stuff.name;
            obj.type = stuff.type;
            if nargin < 3
                state = [];
            end
            if nargin < 4
                option = '';
            end
            
            obj.state = state;
            obj.option = option; 
        end
        
        function disp(obj)
            fprintf(['component #%d:\n', ...
                     '\t name = %s\n', ...
                     '\t type = %s\n', ...
                     '\t option = %s\n', ...
                     '\n'], ...
                     obj.index, obj.name, obj.type, obj.option);
        end
    end
    
end

