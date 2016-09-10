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
        
        function obj = reset(obj)
            obj.cursor = 1;
        end
        
        function obj = reset0(obj)
            obj.cursor = 0;
        end
        
        function len = length(obj)
            len = length(obj.data);
        end
        
        function d = dataList(obj)
            d = cell2mat(obj.data);
        end
    end
    
end

