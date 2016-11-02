classdef DensityMatrix < handle
    %DENSITYMATRIX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        atom
        subspace
        dim
        mat
        col
    end
    
    methods
        function obj = DensityMatrix(atom, subspace)
            obj.atom = atom;
            
            if nargin < 2
                subspace = [Atom.Subspace.GS];
            end
            
            obj.subspace = subspace;
            obj.dim = sum( atom.dim(subspace) );
            obj.mat = eye( obj.dim )/obj.dim;
            obj.col = obj.mat(:);
        end
        
        function rho_lv = getStateVector(obj)
            rho_lv = obj.mat(:);
        end
        
        function set_matrix(obj, m)
            obj.mat = m;
            obj.col = m(:);
            obj.dim = size(m,1);
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
        
        function s = plus(obj1, obj2)
            if Atom.isSameAtom(obj1.atom, obj2.atom)
                s = Algorithm.DensityMatrix(obj1.atom);
                s.mat = obj1.mat + obj2.mat;
                s.col = s.mat(:);
            else
                error('obj1.name=%s but obj2.name=%s', obj1.atom.name, obj2.atom.name);
            end
        end
        
        function n = norm(obj)
            n = norm(obj.mat);
        end
        
        function s = minus(obj1, obj2)
            if Atom.isSameAtom(obj1.atom, obj2.atom)
                s = Algorithm.DensityMatrix(obj1.atom);
                s.mat=obj1.mat - obj2.mat;
                s.col=s.mat(:);
            else
                error('obj1.name=%s but obj2.name=%s', obj1.atom.name, obj2.atom.name);
            end                
        end
        
        function col = getQuasiSteadyStateCol(obj)
            dimG= obj.atom.dim( obj.subspace(1) );
            dimE= obj.atom.dim( obj.subspace(2) );
            
            matE=obj.mat(1:dimE, 1:dimE);
            matG=obj.mat(dimE+1:dimE+dimG, dimE+1:dimE+dimG);
            
            col = [matE(:); matG(:)];            
        end
        
    end

    
end

