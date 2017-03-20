classdef VaporBeamInteraction < Interaction.AbstractInteraction
    %GASBEAMINTERACTION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vapor
        beam
        typeStr
    end
    
    methods
        function obj = VaporBeamInteraction(comp1, comp2)
            obj@Interaction.AbstractInteraction(comp1, comp2);
            
            obj.typeStr = [comp1.stuff.type, '-', comp2.stuff.type];
            switch obj.typeStr 
            case 'vapor-beam'
                obj.vapor = comp1.stuff;
                obj.beam = comp2.stuff;
                obj.option = comp1.option;
            case 'beam-vapor'
                obj.beam = comp1.stuff;
                obj.vapor = comp2.stuff;
                obj.option = comp2.option;
            end
            
            obj.parameter.velocity = 0.0;
            
            obj.parameter.do_velocity_sampling = false;
            obj.parameter.v_sampling.nRaw = 16;%-1;%16;
            obj.parameter.v_sampling.nFine = 32;
            obj.parameter.v_sampling.xRange = 5;
            obj.parameter.v_sampling.gamma = 50; %MHz
            
        end
        
        function obj = calc_matrix(obj)
            obj.matrix.kernel={0.0, 0.0, 0.0};
            switch obj.typeStr  
                case 'vapor-beam'
                    obj.matrix.kernel{1} = obj.vapor_matrix();
                case 'beam-vapor'
                    obj.matrix.kernel{2} = obj.vapor_matrix();
            end
        end
        
        function mat = vapor_matrix(obj)
            switch obj.option
                case 'vacuum'
                    mat = obj.matrix_steady_state();
                case 'vacuum-full'
                    mat = obj.matrix_full_state();
                case 'vacuum-ground'
                    mat = obj.matrix_ground_state();
                case 'vacuum-ground-rate'
                    mat = obj.matrix_ground_state_rate();
                case 'high-pressure'
                    mat = obj.matrix_ground_state_high_pressure();
                otherwise
                    error('non-supported option %s', obj.vapor.option);
            end
        end
        
        function obj = set_velocity(obj, v)
            obj.parameter.velocity = v;
        end 
        
        function detune = get_atom_beam_detuning(obj)
            atom_to_ref_detune = ( obj.vapor.atom.parameters.omega(obj.beam.refTransition)...
                                 - obj.beam.refAtom.parameters.omega(obj.beam.refTransition) ) /2/pi*1e-6;
            detune = obj.beam.detune - atom_to_ref_detune;
        end
        
        function enable_velocity_sampling(obj)
            obj.parameter.do_velocity_sampling = true;
        end
        

    end
    
end

