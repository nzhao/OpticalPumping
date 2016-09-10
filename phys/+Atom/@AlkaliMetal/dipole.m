function res = dipole( obj )
%ELECTRICDIPOLE Summary of this function goes here
%   Detailed explanation goes here
    
    obj.operator.electric_dipole{1} = Atom.ElectricDipole(obj, obj.eigen.eigen_system, [1 2]);
    obj.operator.electric_dipole{2} = Atom.ElectricDipole(obj, obj.eigen.eigen_system, [1 3]);
    res = obj.operator.electric_dipole;
end

