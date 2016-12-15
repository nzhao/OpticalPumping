 classdef VacuumCell < CellSystem.AbstractCellSystem
    %VACUUMCELL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
    end
    
    methods
        function obj = VacuumCell(gas, beam, option)
            obj@CellSystem.AbstractCellSystem(gas, beam);
            if nargin < 3
                option = 'vacuum-full';
            end
            
            obj.set_options(option);
            
            obj.calc_interaction_parameter();
            obj.calc_interaction();
        end
        
        function state = velocity_resolved_evolution(obj, component_index, v, t)            
            state=cell(1, length(v));
            for k=1:length(v)
                obj.interaction{1, component_index}.set_velocity( v(k) ).calc_matrix(); % component{1} must be a 'beam', TODO: improve this.
                state{k} = obj.evolution(component_index, t);
            end
        end
        
        function gammaG = velocity_resolved_GammaG(obj, component_index, v)
            gammaG=cell(1, length(v));
            for k=1:length(v)
                obj.interaction{1, component_index}.set_velocity( v(k) ).matrix_effective_Hamiltonian(); % component{1} must be a 'beam', TODO: improve this.
                gammaG{k} = obj.interaction{1, component_index}.matrix.gamma_g;
            end           
        end
        
        function data = velocity_resolved_pumping(obj, index, t_pump, option)  
            if nargin < 4
                option = 'None';
            end
            
            [~, data.vList, data.uList, data.wList, data.sigmaV] = ...
                obj.interaction{1, index}.velocity_sampling();
            
            state = obj.velocity_resolved_evolution(index, data.vList, t_pump);
            gammaG = obj.velocity_resolved_GammaG(index, data.vList);

            stateG           = cellfun(@(s) s.block(2,2), state, 'UniformOutput', false);            
            data.stateG      = cell2mat(cellfun(@(s) s(:),    stateG, 'UniformOutput', false));
            data.popG        = cell2mat(cellfun(@(s) diag(s), stateG, 'UniformOutput', false));
            data.gammaG      = cell2mat(cellfun(@(s) s(:),    gammaG, 'UniformOutput', false));
            data.gammaG_diag = cell2mat(cellfun(@(s) diag(s), gammaG, 'UniformOutput', false));
            data.absorption  =dot( conj(data.stateG), data.gammaG);
            
            switch option
                case 'diagnose'
                    F1pop=sum(data.popG(6:8, :), 1); F2pop=sum(data.popG(1:5, :), 1);
                    F1gm=sum(data.gammaG_diag(6:8, :), 1); F2gm=sum(data.gammaG_diag(1:5, :), 1);

                    figure;
                    subplot(3, 2, 1); plot(data.vList, F1pop, 'ro-', data.vList, F2pop, 'bd-'); ylim([0 1])
                    subplot(3, 2, 3); semilogy(data.vList, F1gm, 'ro-',data.vList, F2gm, 'bd-')
                    subplot(3, 2, 5); plot(data.vList, sum(data.popG.*data.gammaG_diag,1), 'ko-', data.vList, data.absorption, 'rd-')

                    subplot(3, 2, 2);plot(data.vList, data.uList, 'ro-')
                    subplot(3, 2, 4);plot(data.vList, (F1pop.*F1gm + F2pop.*F2gm).*data.uList', 'ko-')
                    subplot(3, 2, 6);plot(data.vList,  data.absorption.*data.uList', 'ko-')
                case 'None'
                    % do nothing
                otherwise
                    error('non-supported option: %s', option);
            end
        end
        
        function crs_sct = absorption_cross_section(obj, freq, index, t_pump)
            fprintf('freq=%f, index=%d\n', freq, index);
            obj.beam{1}.set_detuning(freq);  % beam idx must be 1.
            data = obj.velocity_resolved_pumping(index, t_pump);
            crs_sct_v = data.absorption.*data.uList';
            crs_sct_v_int = crs_sct_v*data.wList;
            crs_sct = crs_sct_v_int *2*pi*1e6 / obj.interaction{1, index}.beam.photonFlux ...
                      * 1e4 * obj.component{index}.stuff.atom.parameters.abundance; %cm^2
        end
        
        function crs_sct = total_absorption_cross_section(obj, freqList, t_pump)
            vapor_index = obj.get_vapor_index();

            func = @(freq, idx) obj.absorption_cross_section(freq, idx, t_pump);
            
            [m1, m2] = ndgrid(freqList, vapor_index);
            crs_sct = cell2mat(arrayfun(func, m1, m2, 'UniformOutput', false)).';
        end


                
    end
    
end

