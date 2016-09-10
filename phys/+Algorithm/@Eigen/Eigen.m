classdef Eigen < handle
    %EIGEN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        atom
        magB
        eigen_system
        hamiltonian
        operator
        transFreq
    end
    
    methods
        function obj = Eigen(atom, coil)
            obj.atom = atom;
            obj.magB = coil.get_magB;
            
            if isa(atom, 'Atom.AlkaliMetal')
                obj.hamiltonian = Algorithm.AlkaliHamiltonian(atom, obj.magB);
            else
                error('Wrong atom type: %s', class(atom));
            end
            
            obj.eigen_system=obj.diagonalize();
        end
        
        function U=getBasis(obj, k)
            U=obj.eigen_system{k}.U;
        end
        
        function E=getEnergy(obj, k)
            E=obj.eigen_system{k}.E;
        end
        
        function mat=transform(obj, mat0)
            if iscell(mat0)
                mat=cell(size(mat0));
                for k=1:length(mat0)
                    for q=1:size(mat0{k},3)
                        mat{k}(:,:,q) = obj.getBasis(k)'* mat0{k}(:,:,q) * obj.getBasis(k);
                    end
                end
            else
                error('need a cell');
            end
        end

        
        
    end
    
end

