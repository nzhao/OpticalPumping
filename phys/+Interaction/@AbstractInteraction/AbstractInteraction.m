classdef AbstractInteraction < handle
    %ABSTRACTINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type
        index
        components
    end
    
    methods
        function obj = AbstractInteraction(comp1, comp2)
            if comp1.index == comp2.index
                obj.type = 'self';
                obj.index = [comp1.index];
                obj.components={comp1};
            else
                obj.type = 'mutual';            
                obj.index = [comp1.index, comp2.index];
                obj.components={comp1, comp2};
            end
        end
        
        function disp(obj)
            if strcmp(obj.type, 'mutual')
                fprintf('mutual interaction between comp.#%d and comp.#%d\n', ...
                    obj.index(1), obj.index(2));
                fprintf([repmat('=',1,50), '\n']);
                fprintf(['component #%d: \n', ...
                         '\t name =%s\n', ...
                         'component #%d: \n', ...
                         '\t name =%s\n'], ...
                         obj.index(1), ...
                         obj.components{1}.name, ...
                         obj.index(2), ...
                         obj.components{2}.name);
            else
                fprintf('self interaction of comp.#%d \n', ...
                    obj.index(1));
                fprintf([repmat('=',1,50), '\n']);
                fprintf(['component #%d: \n', ...
                         '\t name =%s\n'], ...
                         obj.index(1), ...
                         obj.components{1}.name);
            end
            fprintf([repmat('=',1,50), '\n']);
        end
    end
    
end

