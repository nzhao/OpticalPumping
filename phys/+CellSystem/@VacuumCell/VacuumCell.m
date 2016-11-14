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
            obj.calc_interaction();
        end
        
        function ker = get_kernel(obj, component_index)
            ker=obj.interaction{1, component_index}.matrix.fullG;
        end
        
        function state = evolution(obj, component_index, t)
            state = evolution@CellSystem.AbstractCellSystem(obj, component_index, t);
        end
        
        function [state, gammaG] = velocity_resolved_evolution(obj, component_index, v, t)
            obj.interaction{1, component_index}.set_velocity(v).calc_matrix();
            state = obj.evolution(component_index, t);
            gammaG = obj.interaction{1, component_index}.matrix.gamma_g{1};

        end
        
        function data = velocity_resolved_pumping(obj, index, t_pump, option)  
            if nargin < 4
                option = 'None';
            end
            
            [nSampling, data.vList, data.uList, data.wList, data.sigmaV] = ...
                obj.interaction{1, index}.velocity_sampling(50.0);
            
            dimG = obj.component{index}.dimList(1);
            
            
            data.stateG = zeros(dimG*dimG, nSampling);
            data.popG = zeros(dimG, nSampling);
            data.gammaG=zeros(dimG*dimG, nSampling);
            data.gammaG_diag = zeros(dimG, nSampling);
            data.absorption = zeros(1, nSampling);
            
            for k=1:nSampling
                v = data.vList(k);
                [state, gammaG] = obj.velocity_resolved_evolution(index, v, t_pump);
                stateG = state.block(2,2);
                data.stateG(:, k) = stateG(:);
                data.popG(:, k) = diag(stateG);
                data.gammaG(:, k) = gammaG(:);
                data.gammaG_diag(:, k) = diag(gammaG);
                data.absorption(k) = stateG(:)'*gammaG(:);
            end
            
            switch option
                case 'diagnose'
                    F1pop=sum(data.popG(6:8, :), 1); F2pop=sum(data.popG(1:5, :), 1);
                    F1gm=sum(data.gammaG_diag(6:8, :), 1); F2gm=sum(data.gammaG_diag(1:5, :), 1);

                    figure;
                    subplot(3, 2, 1)
                    plot(data.vList, F1pop, 'ro-', data.vList, F2pop, 'bd-')
                    ylim([0 1])
                    subplot(3, 2, 3)
                    semilogy(data.vList, F1gm, 'ro-',data.vList, F2gm, 'bd-')
                    subplot(3, 2, 5)
                    plot(data.vList, sum(data.popG.*data.gammaG_diag,1), 'ko-', data.vList, data.absorption, 'rd-')

                    subplot(3, 2, 2)
                    plot(data.vList, data.uList, 'ro-')
                    subplot(3, 2, 4)
                    plot(data.vList, (F1pop.*F1gm + F2pop.*F2gm).*data.uList', 'ko-')

                    subplot(3, 2, 6)
                    plot(data.vList,  data.absorption.*data.uList', 'ko-')
                case 'None'
                    
                otherwise
                    error('non-supported option: %s', option);
            end
        end
        
        function crs_sct = absorption_cross_section(obj, index, t_pump)
            data = obj.velocity_resolved_pumping(index, t_pump);
            crs_sct_v = sum(data.absorption, 1).*data.uList';
            crs_sct = crs_sct_v*data.wList *2*pi*1e6 / obj.interaction{1, index}.beam.photonFlux * 1e4;
        end


                
    end
    
end

