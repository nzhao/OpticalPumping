classdef AbstractInteraction < handle
    %ABSTRACTINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type
        index
        option
        component
                
        matrix
        parameter
    end
    
    methods
        %% Constructor
        function obj = AbstractInteraction(comp1, comp2)
            if comp1.index == comp2.index
                obj.type = 'self';
                obj.index = [comp1.index];
                obj.component={comp1};
            else
                obj.type = 'mutual';            
                obj.index = [comp1.index, comp2.index];
                obj.component={comp1, comp2};
            end
        end
        %% IO
        function disp0(obj)
            fprintf([repmat('=',1,50), '\n']);
            if strcmp(obj.type, 'mutual')
                fprintf('mutual interaction between comp.#%d and comp.#%d\n', ...
                    obj.index(1), obj.index(2));
                fprintf([repmat('-',1,50), '\n']);
                fprintf(['component #%d: \n', ...
                         '\t name =%s\n', ...
                         'component #%d: \n', ...
                         '\t name =%s\n'], ...
                         obj.index(1), ...
                         obj.component{1}.name, ...
                         obj.index(2), ...
                         obj.component{2}.name);
            else
                fprintf('self interaction of comp.#%d \n', ...
                    obj.index(1));
                fprintf([repmat('-',1,50), '\n']);
                fprintf(['component #%d: \n', ...
                         '\t name =%s\n'], ...
                         obj.index(1), ...
                         obj.component{1}.name);
            end
            
            
            if isa(obj.matrix, 'struct')
                fprintf([repmat('-',1,50), '\n']);
                matrix_names=fieldnames(obj.matrix);
                for k=1:length(matrix_names)
                    fprintf('\t matrix.%s\n', matrix_names{k} );
                end
            elseif isa(obj.matrix, 'double')
                fprintf([repmat('-',1,50), '\n']);
                [dim1, dim2] = size(obj.matrix);
                fprintf('\t matrix size = [%d %d]\n', dim1, dim2);
            end
            
            if isa(obj.parameter, 'struct')
                fprintf([repmat('-',1,50), '\n']);
                para_names=fieldnames(obj.parameter);
                for k=1:length(para_names)
                    fprintf('\t parameter.%s\n', para_names{k} );
                end
            elseif isa(obj.parameter, 'double')
                fprintf([repmat('-',1,50), '\n']);
                len = length(obj.parameter);
                fprintf('\t parameter length = %d\n', len);
            end
            fprintf([repmat('=',1,50), '\n']);
        end
    end
    
    %% Abstrat methods
    methods (Abstract = true)
        calc_matrix(obj)
    end
    
end

