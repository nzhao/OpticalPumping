classdef VaporBeamInteraction < Interaction.AbstractInteraction
    %GASBEAMINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vapor
        beam
    end
    
    methods
        function obj = VaporBeamInteraction(vapor, beam)
            obj@Interaction.AbstractInteraction(vapor, beam);
            obj.vapor = vapor.stuff;
            obj.beam = beam.stuff;
            obj.option = vapor.option;
            
            obj.parameter.velocityList = 0.0;
            obj.calc_matrix();
        end
        
        function calc_matrix(obj)
            switch obj.option
                case 'vacuum'
                    obj.matrix_steady_state();
                case 'vacuum-full'
                    obj.matrix_full_state();
                case 'pressure'
                    obj.matrix_ground_state();
                otherwise
                    error('non-supported option %s', obj.vapor.option);
            end
        end
        
        function set_velocity_list(obj, varargin)
            if nargin == 2
                v=varargin{1};
                obj.parameter.velocityList=v;
            elseif nargin == 4
                minV=varargin{1}; maxV=varargin{2}; nV=varargin{3};
                obj.parameter.velocityList=linspace(minV, maxV, nV);
            end
                
        end
    end
    
end

