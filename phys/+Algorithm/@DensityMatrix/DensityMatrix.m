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
            obj.col = obj.Col2Mat();
        
        end
        
        function col = getCol(obj, option)
            if nargin == 1
                option='vacuum-full';
            end
            
            switch option
                case 'vacuum-full'
                    col = obj.col;
                case 'vacuum'
                    col = obj.getQuasiSteadyStateCol;
                case 'vacuum-ground'
                    col = obj.getGroundStateCol;
                case 'vacuum-ground-rate'
                    col = obj.getGroundStatePopulationCol;
                otherwise
                    error('non-supported option %s', option);
            end
        end
        
        
        function setCol(obj, col, option)
            if nargin == 1
                option='vacuum-full';
            end
            
            switch option
                case 'vacuum-full'
                    obj.col = col;
                case 'vacuum'
                    obj.setQuasiSteadyStateCol(col);
                case 'vacuum-ground'
                    obj.setGroundStateCol(col);
                case 'vacuum-ground-rate'
                    obj.setGroundStatePopulationCol(col);
                otherwise
                    error('non-supported option %s', option);
            end
            obj.mat = obj.Mat2Col();
         end
        
         
        function mat_blk = block(obj, k, q)
            startK = obj.first(k); endK = obj.last(k);
            startQ = obj.first(q); endQ = obj.last(q);
            mat_blk = obj.mat( startK:endK, startQ:endQ);
        end
        
        function col = Col2Mat(obj)
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
        
        function mat = Mat2Col(obj)
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
        
        function set_matrix(obj, m)
            obj.mat = m;
            obj.col = obj.Col2Mat();
        end
        
        function val = meanGS(obj, op)
            nSize=size(op, 3);
            val = zeros(nSize, 1);
            dimGS = obj.dimList(end);
            for k=1:nSize
                op_mat = op(:,:, k);
                val(k) =  op_mat(:)'*obj.col(end-dimGS*dimGS+1:end);
            end
        end

        
        function val = mean(obj, op)
            nSize=size(op, 3);
            val = zeros(1, nSize);
            for k=1:nSize
                op_mat = op(:,:, k);
                val(k) =  op_mat(:)'*obj.col;
            end
        end
        
        function new_rho = evolve( obj, ker, dt, option)
            new_col = expm(-ker*dt)*obj.getCol(option);
            new_rho = Algorithm.DensityMatrix(obj.atom, obj.subspace);
            new_rho.setCol(new_col, option);
        end
        
        function s = plus(obj1, obj2)
            if Atom.isSameAtom(obj1.atom, obj2.atom)
                s = Algorithm.DensityMatrix(obj1.atom);
                s.set_matrix( obj1.mat + obj2.mat );
                s.col = s.Col2Mat();
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
                s.col=s.Col2Mat();
            else
                error('obj1.name=%s but obj2.name=%s', obj1.atom.name, obj2.atom.name);
            end                
        end
        
        function col = mtimes(obj, f)
            col = obj.Col2Mat() * f;
        end
        
        function mat = equilibrium_state_matrix(obj)
            mat = zeros( obj.dim );
            startGS = obj.first(end); endGS=obj.last(end); dimGS = obj.dimList(end);
            mat(startGS:endGS,startGS:endGS) = eye(dimGS)/dimGS; 
        end
        
        function col = getQuasiSteadyStateCol(obj)
            matE = obj.block(1, 1); matG=obj.block(2, 2);
            col = [matE(:); matG(:)];            
        end
        
        function col = getGroundStateCol(obj)
            matG=obj.block(2, 2);
            col = matG(:);
        end
        
        function col = getGroundStatePopulationCol(obj)
            matG=obj.block(2, 2);
            col = diag(matG);
        end
        
        function setQuasiSteadyStateCol(obj, col1)
            obj.col = zeros(obj.dim*obj.dim, 1);
            dimE = obj.dimList(1); dimG = obj.dimList(2);
            obj.col(1:dimE*dimE) = col1(1:dimE*dimE);
            obj.col(end-dimG*dimG+1:end) = col1(end-dimG*dimG+1:end);
        end
        
        function setGroundStateCol(obj, col1)
            obj.col = zeros(obj.dim*obj.dim, 1);
            dimG = obj.dimList(2);
            obj.col(end-dimG*dimG+1:end) = col1(end-dimG*dimG+1:end);
        end

        function setGroundStatePopulationCol(obj, col1)
            obj.col = zeros(obj.dim*obj.dim, 1);
            matG = diag(col1);
            dimG = obj.dimList(2);
            obj.col(end-dimG*dimG+1:end) = matG(:);
        end
        
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

