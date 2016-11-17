classdef DensityMatrix < handle
    %DENSITYMATRIX Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        atom
        subspace
        dim
        dimList
        last
        first
        mat
        col
    end
    
    methods
        function obj = DensityMatrix(atom, subspace)
            obj.atom = atom;
            
            if nargin < 2
                subspace = [Atom.Subspace.GS];
            end
            
            obj.subspace = sort(subspace, 'descend');
            obj.dimList = atom.dim(obj.subspace);
            obj.dim = sum( obj.dimList );
            obj.last = cumsum(obj.dimList);
            obj.first = obj.last - obj.dimList + 1;
            
            obj.mat = obj.equilibrium_state_matrix();
            %obj.col = obj.mat(:);
            obj.col = obj.getCol();
        
        end
 
        function mat_blk = block(obj, k, q)
            startK = obj.first(k); endK = obj.last(k);
            startQ = obj.first(q); endQ = obj.last(q);
            mat_blk = obj.mat( startK:endK, startQ:endQ);
        end
        
        function col = getCol(obj)
            col = zeros(obj.dim*obj.dim, 1);
            pos = 0;
            for k = 1:length(obj.subspace)
                for q = 1:length(obj.subspace)
                    mat_kq = obj.block(k,q);
                    col_kq = mat_kq(:);
                    len_kq = length(col_kq);
                    col(pos+1:pos+len_kq) = col_kq;
                    pos=pos+len_kq;
                end
            end
        end
        
        function mat = getMat(obj)
            mat = zeros(obj.dim);
            pos = 0;
            for k = 1:length(obj.subspace)
                for q = 1:length(obj.subspace)
                    startK = obj.first(k); endK = obj.last(k); dimK = obj.dimList(k); 
                    startQ = obj.first(q); endQ = obj.last(q); dimQ = obj.dimList(q);
                    len_kq = dimK*dimQ;
                    mat( startK:endK, startQ:endQ) = ...
                        reshape( obj.col(pos+1:pos+len_kq), ...
                                [obj.dimList(k), obj.dimList(q)] );
                    pos = pos+len_kq;
                end
            end
        end
        
%         function rho_lv = getStateVector(obj)
%             rho_lv = obj.mat(:);
%         end
        
        function set_matrix(obj, m)
            obj.mat = m;
            %obj.col = m(:);
            obj.col = getCol();
%             obj.dim = size(m,1);
        end
        
        function set_col(obj, col)
            obj.col = col;
            obj.mat = obj.getMat();
        end
        
        function val = mean(obj, op)
            nSize=size(op, 3);
            val = zeros(1, nSize);
            for k=1:nSize
                op_mat = op(:,:, k);
                %val(k) = op_mat(:)'*obj.mat(:);
                val(k) =  op_mat(:)'*obj.col;
            end
        end
        
        function new_rho = evolve( obj, ker, dt)
            new_col = expm(-ker*dt)*obj.col;
            new_rho = Algorithm.DensityMatrix(obj.atom, obj.subspace);
            new_rho.set_col(new_col);
            %new_rho.set_matrix( reshape(new_col, [obj.dim, obj.dim]) );
        end
        
        function s = plus(obj1, obj2)
            if Atom.isSameAtom(obj1.atom, obj2.atom)
                s = Algorithm.DensityMatrix(obj1.atom);
                s.set_matrix( obj1.mat + obj2.mat );
                s.col = s.getCol();
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
                s.set_matrix( obj1.mat - obj2.mat );
                s.col=s.getCol();
            else
                error('obj1.name=%s but obj2.name=%s', obj1.atom.name, obj2.atom.name);
            end                
        end
        
        function col = mtimes(obj, f)
            col = obj.getCol() * f;
        end
        
        function mat = equilibrium_state_matrix(obj)
            mat = zeros( obj.dim );
            startGS = obj.first(end); endGS=obj.last(end); dimGS = obj.dimList(end);
            mat(startGS:endGS,startGS:endGS) = eye(dimGS)/dimGS; 
            %obj.col = obj.getCol();
        end
        
%         function mat = mat_restrict(obj)
%             dimG= obj.atom.dim( obj.subspace(1) );
%             dimE= obj.atom.dim( obj.subspace(2) );
%             
%             matE=obj.mat(1:dimE, 1:dimE);
%             matG=obj.mat(dimE+1:dimE+dimG, dimE+1:dimE+dimG);
%             mat{1}=matG; mat{2}=matE;
%         end
        
        function col = getQuasiSteadyStateCol(obj)
            matE = obj.block(1, 1); matG=obj.block(2, 2);
            col = [matE(:); matG(:)];            
        end
        
        
%         function mat = restrict(obj, idx)
%             matcell = obj.mat_restrict();
%             mat = matcell{idx};
%         end
        
        function pop = population(obj, idx)
            subspace_mat = obj.block(idx, idx);
            pop = diag(subspace_mat);
            
            imag_residual = norm(imag(pop));
            if imag_residual> 1e-10
                warning('imag part of population is not zero, %f.', imag_residual);
            end
        end
        
        function coh = max_coherence(obj, idx1, idx2)
            if nargin == 2 || idx1 == idx2
                subspace_mat = obj.block(idx1, idx1);
                coh_mat = subspace_mat-diag(diag(subspace_mat));
            elseif nargin == 3 && idx1 ~= idx2
                coh_mat = obj.block(idx1, idx2);
            else
                error('wrong input');
            end
            coh = max(abs(coh_mat(:)));
        end
    end

    
end

