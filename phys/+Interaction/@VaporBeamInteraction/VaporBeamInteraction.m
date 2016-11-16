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
            
            obj.parameter.velocity = 0.0;
            %obj.calc_matrix();
            
            obj.parameter.sampling_nRaw = 16;
            obj.parameter.sampling_nFine = 16;
            obj.parameter.sampling_xRange = 5;
            obj.parameter.sampling_gamma = 50; %MHz
        end
        
        function obj = calc_matrix(obj)
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
        
        function obj = set_velocity(obj, v)
            obj.parameter.velocity = v;
        end 
        
        function [len, vList, uList, wList, sigmaV] = velocity_sampling(obj)
            nRaw = obj.parameter.sampling_nRaw; 
            nFine = obj.parameter.sampling_nFine;
            xRange = obj.parameter.sampling_xRange; 
            gamma = obj.parameter.sampling_gamma;
  
            center_freq = obj.beam.detune;
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
                npoint = round(nFine* (fine_range(k,2) - fine_range(k,1))/100 );
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

