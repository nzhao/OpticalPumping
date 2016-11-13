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
        
        function [state, stateList, cross_section] = evolution(obj, component_index, t, option)
            if nargin < 4
                option = 'None';
            end
            
            switch option
                case 'DopplerAverage'
                    nSampling = 64; x = 5;
                    comp = obj.component{component_index};
                    
                    dim = comp.state.dim;
                    sigmaV = comp.stuff.dopplerBroadening();
                    
                    [vList, wList] = comp.velocity_sampling(nSampling, x);
                    stateList = cell(1, nSampling);
                    col = zeros(dim*dim, 1);
                    cross_section = 0;
                    for k = 1:nSampling
                        v = vList(k);
                        obj.interaction{1, component_index}.set_velocity(v).calc_matrix();
                        stateList{k}=evolution@CellSystem.AbstractCellSystem(obj, component_index, t);
                        
                        col_e = obj.interaction{1, component_index}.matrix.gamma_e{1}(:);
                        col_g = obj.interaction{1, component_index}.matrix.gamma_g{1}(:);
                        mat_eg = zeros(stateList{k}.dimList(1), stateList{k}.dimList(2));
                        mat_ge = zeros(stateList{k}.dimList(2), stateList{k}.dimList(1));
                        gamma = [col_e; mat_eg(:); mat_ge(:); col_g];

                        cross_section_k = gamma'*stateList{k}.getCol();
                        cross_section = cross_section + cross_section_k* exp(-v*v/2/sigmaV/sigmaV)/sqrt(2*pi)/sigmaV * wList(k);
                        col = col + stateList{k} * exp(-v*v/2/sigmaV/sigmaV)/sqrt(2*pi)/sigmaV * wList(k);
                    end
                    state = Algorithm.DensityMatrix(stateList{k}.atom, stateList{k}.subspace);
                    state.set_col(2.0*col);
                    
                case 'None'
                    state = evolution@CellSystem.AbstractCellSystem(obj, component_index, t);
                    stateList=cell();
                
                otherwise
                    error('non-surpported option %s', option);
            end
        end
                
    end
    
end

