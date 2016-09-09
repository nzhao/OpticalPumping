classdef AlkaliMetal < handle
    %ALKALIMETAL Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        parameters
        
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
        
        rho
    end
    
    methods
        function obj = AlkaliMetal(name)
            obj.name = name;
            obj.parameters = Atom.AtomParameters(name);
            
            obj.I = obj.parameters.spin_I; 
            obj.a = obj.I-0.5; obj.b = obj.I + 0.5;
            
            obj.gI = 2*obj.I+1;  
            obj.gJ = 2*obj.J+1;
            obj.dim = obj.gI * obj.gJ;
            
            obj.mat = obj.spinMatrix();
            
            obj.rho = Algorithm.DensityMatrix(obj);
        end
        
        function set_eigen(obj, coil)
            obj.eigen=Algorithm.Eigen(obj, coil);
            
            obj.matEigen.Imat = obj.eigen.transform(obj.mat.Imat);
            obj.matEigen.Smat = obj.eigen.transform(obj.mat.Smat);
            obj.matEigen.Fmat = obj.eigen.transform(obj.mat.Fmat);
            obj.matEigen.IS = obj.eigen.transform(obj.mat.IS);
            obj.matEigen.F2 = obj.eigen.transform(obj.mat.F2);
            obj.matEigen.mu = obj.eigen.transform(obj.mat.mu);
           
            obj.operator = obj.spinOperator();
            obj.dipole();
        end
        
        function res = energy_spectrum(obj, state, minB, maxB, nB)
            res.magB=linspace(minB, maxB, nB);
            res.energy = zeros(obj.dim(state), nB); 
            
            coil=Condition.Coil('coil');
            
            for k = 1:nB
                obj.set_eigen( coil.set_magB(res.magB(k)) );
                res.energy(:, k) = obj.eigen.getEnergy(state);
            end
        end
        
        function v = mean_vector( obj, opt )
            if nargin < 2
                opt = 1;
            end

            i_mat = obj.matEigen.Imat{opt};
            s_mat = obj.matEigen.Smat{opt};
            f_mat = obj.matEigen.Fmat{opt};
            v.I = obj.rho.mean(i_mat);
            v.S = obj.rho.mean(s_mat);
            v.F = obj.rho.mean(f_mat);
        end
        
    end
    
end
