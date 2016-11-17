classdef AbstractCellSystem < handle
    %ABSTRACTCELLSYSTEM Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gas
        beam
        component
        nComponent
        
        interaction        
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
        
        function interaction = calc_interaction(obj)
            obj.interaction = cell(obj.nComponent);
            for k = 1:obj.nComponent
                for q = k:obj.nComponent
                    obj.interaction{k, q} = obj.component_interaction(k,q);
                    obj.interaction{q, k} = obj.interaction{k, q};
                end
            end
            interaction = obj.interaction;
        end
        
        function state = evolution(obj, component_index, t)
            ker = obj.get_kernel(component_index);
            rho = obj.component{component_index}.state;
            if length(t) == 1
                state = rho.evolve(2*pi*ker, t);
            else
                state = cell(1, length(t));
                for k=1:length(t)
                    fprintf('t = %f\n', t(k));
                    state{k} = rho.evolve(2*pi*ker, t(k));
                end
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
        ker = get_kernel(obj, component_index)
    end
    
end

