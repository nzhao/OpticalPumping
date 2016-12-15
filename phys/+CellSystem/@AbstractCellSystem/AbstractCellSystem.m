classdef AbstractCellSystem < handle
    %ABSTRACTCELLSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gas
        beam
        component
        nComponent
        
        interaction
        interaction_parameter
    end
    
    methods
        %% Constructor
        function obj = AbstractCellSystem(gas, beam)
            if iscell(gas)
                obj.gas = gas;
            else
                obj.gas =  {gas};
            end
            
            if iscell(beam)
                obj.beam = beam;
            else
                obj.beam = {beam};
            end
            
            stuff = [obj.beam, obj.gas];
            obj.nComponent = length(stuff);
            obj.make_component(stuff);
        end
        
        %% Proc
        function obj = make_component(obj, stuff)
            obj.component = cell( 1, obj.nComponent );
            for k=1:length(stuff)
                obj.component{k} = CellSystem.Component(k, stuff{k});                
                obj.component{k}.set_frequency();
                
            end    
        end
        
        function calc_interaction_parameter(obj)
            obj.interaction_parameter = cellfun(@(s) obj.component_interaction_parameter(s), ...
                                                num2cell(1:obj.nComponent), 'UniformOutput', false);
        end
        
        function interaction = calc_interaction(obj)
            obj.interaction = cell(obj.nComponent);
            for k = 1:obj.nComponent
                for q = k:obj.nComponent %q>=k
                    obj.interaction{k, q} = obj.component_interaction(k,q).calc_matrix();
                    obj.interaction{q, k} = obj.interaction{k, q};
                end
            end
            interaction = obj.interaction;
        end
        
        function state = evolution(obj, component_index, t)
            ker = obj.get_component_kernel(component_index);
            rho = obj.component{component_index}.state;
            option = obj.component{component_index}.option;
            state = arrayfun(@(tval) rho.evolve(2*pi*ker,tval, option), t, 'UniformOutput', false);

            if length(t) == 1
                state = state{1};
            end
        end

        %% Input Interface
        function obj = set_options(obj, varargin)
            if nargin == 2
                opt=varargin{1};
                for k=1:obj.nComponent
                    obj.component{k}.option = opt;
                end
            elseif nargin == 3
                idx = varargin{1};  opt = varargin{2};
                obj.component{idx}.option = opt;
            else
                error('wrong parameters');
            end
        end
        
        %% Output Interface
        function interaction = get_interaction(obj, k, q)
            if nargin == 2
                q = k;
            end
            interaction = obj.interaction{k,q};
        end
        
        function ker = get_component_kernel(obj, component_index)
            ker = 0;
            for k=1:obj.nComponent
                ker = ker + obj.interaction{component_index, k}.getKernel(component_index);
            end
        end
        
        function idx = get_vapor_index(obj)
            idx = 1:obj.nComponent;
            isVapor = cellfun(@(s) strcmp(s.type, 'vapor'), obj.component);
            idx = idx(logical(isVapor));
        end

        function idx = get_buffer_index(obj)
            idx = 1:obj.nComponent;
            isBuffer = cellfun(@(s) strcmp(s.type, 'buffer'), obj.component);
            idx = idx(logical(isBuffer));
        end
        
        function disp_component(obj)
            fprintf([repmat('=',1,50), '\n']);
            fprintf('There are %d components included.\n', obj.nComponent);
            fprintf([repmat('-',1,50), '\n']);
            for k=1:obj.nComponent
                obj.component{k}.disp;
            end
            fprintf([repmat('=',1,50), '\n']);
        end
    end
    
    methods (Abstract = true)
%         ker = get_kernel(obj, component_index)
    end
    
end

