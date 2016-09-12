classdef DensityMatrix < handle
    %DENSITYMATRIX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        atom
        dim
        mat
        col
    end
    
    methods
        function obj = DensityMatrix(atom, opt)
            obj.atom = atom;
            
            if nargin < 2
                obj.mat = eye(atom.dim(1))/atom.dim(1);
                obj.dim = atom.dim(1);
            else
                sum_dim = sum( atom.dim(opt) );
                obj.mat = eye( sum_dim )/sum_dim;
                obj.dim = sum_dim;
            end
            obj.col = obj.mat(:);
        end
        
        function rho_lv = getStateVector(obj)
            rho_lv = obj.mat(:);
        end
        
        function set_matrix(obj, m)
            obj.mat = m;
            obj.col = m(:);
        end
        
        function val = mean(obj, op)
            nSize=size(op, 3);
            val = zeros(1, nSize);
            for k=1:nSize
                op_mat = op(:,:, k);
                val(k) = op_mat(:)'*obj.mat(:);
            end
        end
        
        function new_rho = evolve( obj, ker, dt)
            new_col = expm(-ker*dt)*obj.col;
            new_rho = Algorithm.DensityMatrix(obj.atom);
            new_rho.set_matrix( reshape(new_col, [obj.dim, obj.dim]) );
        end
        
    end

    
end

