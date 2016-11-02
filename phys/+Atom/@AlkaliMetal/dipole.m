function electric_dipole = dipole( obj )
%ELECTRICDIPOLE Summary of this function goes here
%   Detailed explanation goes here
    
    electric_dipole{1} = Atom.ElectricDipole(obj, obj.eigen.eigen_system, [1 2]);
    electric_dipole{2} = Atom.ElectricDipole(obj, obj.eigen.eigen_system, [1 3]);
end

