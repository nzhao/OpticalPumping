classdef AlkaliMetal < handle
    %ALKALIMETAL Summary of this class goes here
    %   Detailed explanation goes here
    properties
        name
        parameters
        hasSpin = 1
        
        I
        S = 0.5
        
        a
        b
        
        J=[0.5, 0.5, 1.5]
        
        gI
        gJ
        
        dim
        
        mat
        matEigen
        eigen
        
        operator
        
%        zeeman_terms
        
%         rho
    end
    
    methods
        function obj = AlkaliMetal(name, coil)
            obj.name = name;
            obj.parameters = Atom.AtomParameters(name);
            
            obj.I = obj.parameters.spin_I; 
            obj.a = obj.I-0.5; obj.b = obj.I + 0.5;
            
            obj.gI = 2*obj.I+1;  
            obj.gJ = 2*obj.J+1;
            obj.dim = obj.gI * obj.gJ;
            
            obj.mat = obj.spinMatrix();
            
%             obj.rho = Algorithm.DensityMatrix(obj);
            
            if nargin > 1
                obj.set_eigen(coil);
            end
            
        end
        
        function set_eigen(obj, coil)
            obj.eigen=Algorithm.Eigen(obj, coil{3});
            
            obj.matEigen.Imat = obj.eigen.transform(obj.mat.Imat);
            obj.matEigen.Smat = obj.eigen.transform(obj.mat.Smat);
            obj.matEigen.Fmat = obj.eigen.transform(obj.mat.Fmat);
            obj.matEigen.IS = obj.eigen.transform(obj.mat.IS);
            obj.matEigen.F2 = obj.eigen.transform(obj.mat.F2);
            obj.matEigen.mu = obj.eigen.transform(obj.mat.mu);
            for k=1:3
                obj.matEigen.zeeman_terms(:,:,k) = - obj.matEigen.mu{1}(:,:,k)*coil{k}.magB/(2*pi*h_bar)*1e-6;
            end
            
%             obj.dipole();
            obj.operator = obj.spinOperator();
        end
        
        function res = energy_spectrum(obj, state, coil)
            coilx=coil{1};
            coily=coil{2};
            coilz=coil{3};
            res.magB = coilz.iter.dataList;
            res.energy = zeros(obj.dim(state), ...
                               coilz.iter.length); 
            
            coilz.restart0();
            while coilz.iter.hasNext
                obj.set_eigen( {coilx, coily, coilz.move_forward} );
                res.energy(:, coilz.iter.cursor) ...
                    = obj.eigen.getEnergy(state);
            end
        end
        
        function S = mean_spin(obj, rho)
            s_mat = obj.matEigen.Smat{Atom.Subspace.GS};
            S = rho.mean(s_mat);
        end
        
        function v = mean_vector( obj, rho, space )
            if nargin < 3
                space = Atom.Subspace.GS;
            end

            i_mat = obj.matEigen.Imat{space};
            s_mat = obj.matEigen.Smat{space};
            f_mat = obj.matEigen.Fmat{space};
            v.I = rho.mean(i_mat);
            v.S = rho.mean(s_mat);
            v.F = rho.mean(f_mat);
        end
        
        function p = proj_op(obj, k, space)
            if nargin < 3
                space = Atom.Subspace.GS;
            end
            p = zeros( obj.dim(space) );
            p(k,k) = 1;
        end
        
    end
    
end

