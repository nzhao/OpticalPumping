classdef Gas < handle
    %GAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        name
        atom
        type
        density
        pressure
        temperature
        
        gamma2 = 0
    end
    
    methods
        function obj = Gas(atom, type, temperature, pressure, name)
            if nargin < 5
                name = atom.name;
            end
            obj.name = name;
            obj.atom = atom;
            obj.type = type;
            obj.temperature = temperature;

            if nargin < 4
                pressure = obj.getPressure(temperature);
            end
            obj.pressure = pressure;
            
            obj.density = pressure / kB / temperature;
        end
        
    end
    
end

