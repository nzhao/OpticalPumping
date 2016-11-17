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
        velocity
        transition
        
        gamma2 = 0
    end
    
    methods
        function obj = Gas(atom, type, temperature, transition, pressure, name)
            if nargin < 6
                name = atom.name;
            end
            obj.name = name;
            obj.atom = atom;
            obj.type = type;
            obj.temperature = temperature;

            if nargin < 5
                pressure = obj.getPressure(temperature);
            end
            obj.pressure = pressure;
            
            if nargin < 4
                transition = '';
            end
            obj.transition = transition;
            
            try
                abundance = atom.parameters.abundance;
            catch
                abundance = 1;
            end
            obj.density = pressure / kB / temperature*abundance;

            obj.velocity = obj.dopplerBroadening();
        end
        
        function obj = set_temperature(obj, temperature)
            if strcmp(obj.type, 'vapor')
                obj.pressure = obj.getPressure(temperature);
                obj.density = obj.pressure / kB / temperature;
                mass = Atom.AtomParameters(obj.name).mass / avogadro * 1e-3;
                obj.velocity = sqrt( kB*temperature / mass );
            end
        end
        
    end
    
end

