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
            
            obj.parameter.sampling_nRaw = 16;
            obj.parameter.sampling_nFine = 32;
            obj.parameter.sampling_xRange = 5;
            obj.parameter.sampling_gamma = 50; %MHz
            
        end
        
        function obj = calc_matrix(obj)
            mat = obj.vapor_matrix();
            switch obj.typeStr  
                case 'vapor-beam'
                    obj.matrix.kernel1 = mat;
                    obj.matrix.kernel2 = 0.0;
                    obj.matrix.kernel12 = 0.0;
                case 'beam-vapor'
                    obj.matrix.kernel1 = 0.0;
                    obj.matrix.kernel2 = mat;
                    obj.matrix.kernel12 = 0.0;
            end
            obj.matrix.kernel={obj.matrix.kernel1, ...
                               obj.matrix.kernel2, ...
                               obj.matrix.kernel12}; 
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
        
        function [len, vList, uList, wList, sigmaV] = velocity_sampling(obj)
            nRaw = obj.parameter.sampling_nRaw; 
            nFine = obj.parameter.sampling_nFine;
            xRange = obj.parameter.sampling_xRange; 
            gamma = obj.parameter.sampling_gamma;
  
            center_freq = obj.get_atom_beam_detuning();
            refTrans = obj.beam.refTransition;
            transFreq =obj.vapor.atom.eigen.transFreq{1+refTrans, 1}(:);
            
            
            resonance = center_freq - transFreq;
            intervals = [resonance - gamma, resonance + gamma];
            v_intervals = 2*pi* intervals *1e6/obj.beam.wavenumber;
            
            sigmaV = obj.vapor.velocity;
            v_range = xRange*[-sigmaV, sigmaV];
            
            [raw_range, fine_range] = interval_complement(v_intervals, v_range);
            
            vRaw = cell(1, size(raw_range, 1));
            wRaw = cell(1, size(raw_range, 1));
            for k=1:size(raw_range, 1)
                npoint = round(nRaw * (raw_range(k,2) - raw_range(k,1))/1000 );
                [vRaw{k}, wRaw{k} ] = lgwt(npoint, raw_range(k, 1), raw_range(k, 2));
            end
            vFine = cell(1, size(fine_range, 1));
            wFine = cell(1, size(fine_range, 1));
            for k=1:size(fine_range, 1)
                npoint = round(nFine* (fine_range(k,2) - fine_range(k,1))/50 );
                [vFine{k}, wFine{k} ] = lgwt(npoint, fine_range(k, 1), fine_range(k, 2));
            end
            vListTemp = cell2mat([vFine(:); vRaw(:)]);
            wListTemp = cell2mat([wFine(:); wRaw(:)]);
            [vList, idx] = sort(vListTemp);
            wList = wListTemp(idx);

            len = length(vList);
            uList = exp(-vList.*vList/2/sigmaV/sigmaV)/sqrt(2*pi)/sigmaV;
        end
    end
    
end

