classdef iterator < handle
    %ITERATOR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        data
        cursor = 1
    end
    
    methods
        function obj = iterator(data)
            obj.data = data;
        end
        
        function item = current(obj)
            item = obj.data{obj.cursor};
        end
        
        function item = next(obj)
            if obj.hasNext 
                obj.cursor = obj.cursor + 1;
                item = obj.data{obj.cursor};
            end
        end
        
        function tf = hasNext(obj)
            tf = ( obj.cursor < length(obj.data) );
        end
    end
    
end

