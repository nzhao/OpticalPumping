classdef BufferGas
    %BUFFERGAS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        atom
        temperature
        pressure
        density
        name
        type
    end
    
    methods
        function obj = BufferGas(atom, temperature, pressure, name)
            if nargin < 4
                name = atom.name;
            end
            
            obj.atom = atom;
            obj.temperature = temperature;
            obj.pressure = pressure;
            obj.name = name;
            obj.type = 'buffer';
            
            try
                abundance = atom.parameters.abundance;
            catch
                abundance = 1;
            end
            obj.density = pressure / kB / temperature*abundance;
        end
        
        function val=getPressure(obj)
            val=obj.pressure;
        end
    end
    
end
