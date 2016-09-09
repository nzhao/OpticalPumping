classdef Gas < handle
    %GAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        atom
        type
        density
        pressure
        temperature
        
        gamma2 = 0
    end
    
    methods
        function obj = Gas(atom, type, temperature, pressure)
            obj.atom = atom;
            obj.type = type;
            obj.temperature = temperature;
            if nargin < 4
                pressure = atom.getPressure(temperature);
            end
            obj.pressure = pressure;
            
            obj.density = pressure / kB / temperature;
        end
    end
    
end
