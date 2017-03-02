classdef VaporCell < CellSystem.AbstractCellSystem
    %VAPORCELL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = VaporCell(gas, beam, option)
            obj@CellSystem.AbstractCellSystem(gas, beam);
            if nargin < 3
                option = 'vacuum-full';
            end
            
            obj.set_options(option);
            obj.calc_interaction();
        end
       
        %% Absorption Cross Section
        function crs_sct = absorption_cross_section(obj, freq, beam_index, vapor_index, t_pump)
            fprintf('freq=%f, index=%d\n', freq, vapor_index);
            obj.stuff.beam{beam_index}.set_detuning(freq); 
            
            data = obj.velocity_resolved_pumping(beam_index, vapor_index, t_pump);
            crs_sct_v = data.absorption.*data.uList';
            crs_sct_v_int = crs_sct_v*data.wList;
            crs_sct = crs_sct_v_int *2*pi*1e6 / obj.interaction{1, vapor_index}.beam.photonFlux ...
                      * 1e4 * obj.component{vapor_index}.stuff.atom.parameters.abundance; %cm^2
        end
        
        function crs_sct = total_absorption_cross_section(obj, beam_index, freqList, t_pump)
            vapor_index = obj.get_vapor_index();
            [m1, m2] = ndgrid(freqList, vapor_index);
            func = @(freq, vapor_idx) obj.absorption_cross_section(freq, beam_index, vapor_idx, t_pump);
            crs_sct = cell2mat(arrayfun(func, m1, m2, 'UniformOutput', false)).';
        end

    end
    
end

