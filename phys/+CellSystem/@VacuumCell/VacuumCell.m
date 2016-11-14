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
        
        function [stateList, gamma_col] = velocity_resolved_evolution(obj, component_index, vList, t)
            stateList=cell(1, length(vList));
            dim = 64;
            gamma_col=zeros(dim, length(vList));
            for k=1:length(vList)
                v=vList(k);
                obj.interaction{1, component_index}.set_velocity(v).calc_matrix();
                stateList{k} = obj.evolution(component_index, t);
                gamma_col(:, k) = obj.interaction{1, component_index}.matrix.gamma_g{1}(:);
            end
        end
        
        function [res, data] = velocity_average(obj, idx, t)
            %nSampling = 256; x = 5;
            %[vList, wList, sigmaV] = obj.component{idx}.velocity_sampling(nSampling, x);
            [vList, wList, sigmaV] = obj.interaction{1, idx}.velocity_sampling(50.0);
            nSampling = length(vList);
            uList = exp(-vList.*vList/2/sigmaV/sigmaV)/sqrt(2*pi)/sigmaV;
            [stateList, gamma_col] = obj.velocity_resolved_evolution(idx, vList, t);
            
            dimG = stateList{1}.dimList(1);
            
            data.vList = vList;
            data.wList = wList;
            data.uList = uList;
            data.stateList = stateList;
            data.gammaG = gamma_col;
            
            data.matG = zeros(dimG*dimG, nSampling);
            data.popG = zeros(dimG, nSampling);
            %data.gammaG = zeros(dimG*dimG, nSampling);
            data.gammaG_diag = zeros(dimG, nSampling);
            data.sbsorption = zeros(1, nSampling);
            
            
            for k=1:nSampling
                matG = stateList{k}.block(2,2);
                data.matG(:, k) = matG(:);
                data.popG(:, k) = diag(matG);
                %data.gammaG(:, k) = gamma_col(end-dimG*dimG+1:end);
                data.gammaG_diag(:, k) = diag(reshape(data.gammaG(:, k), [dimG, dimG]));
                data.absorption(k) = data.matG(:, k)'*data.gammaG(:, k);
            end
            
            func_val = data.absorption.*data.uList';
            res = func_val*wList;
        end


                
    end
    
end

