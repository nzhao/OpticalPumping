classdef Eigen < handle
    %EIGEN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        atom
        eigen_system
        hamiltonian
        operator
    end
    
    methods
        function obj = Eigen(atom, coil)
            obj.atom = atom;
            magB = coil.magB;
            
            if isa(atom, 'Atom.AlkaliMetal')
                obj.hamiltonian = Proc.AlkaliHamiltonian(atom, magB);
            else
                error('Wrong atom type: %s', class(atom));
            end
            
            obj.eigen_system=obj.diagonalize();
        end
        
        
    end
    
end

