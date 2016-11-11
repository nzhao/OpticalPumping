classdef Component < handle
    %COMPONENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        index
        name
        type
        hasDynamics
        
        stuff
        state
%        steady_state
        option
        frequency
    end
    
    methods
        function obj = Component(idx, stuff)
            obj.index = idx;
            obj.stuff = stuff;
            obj.name = stuff.name;
            obj.type = stuff.type;

            switch obj.type
                case 'beam'
                    obj.hasDynamics = 0;
                case 'vapor'
                    obj.hasDynamics = 1;
                    obj.state = stuff.atom.operator.equilibrium_state{1+stuff.transition};
                otherwise
                    warning('non-supported type %s', obj.type);
            end
        end
        
        function freq = set_frequency(obj)
            switch obj.type
                case 'beam'
                    freq = obj.stuff.frequency;
                case 'vapor'
                    vapor = obj.stuff;
                    freq = vapor.atom.parameters.omega(vapor.transition)/2/pi;
                otherwise
                    warning('non-supported type %s', obj.type);
            end
            obj.frequency = freq;
        end
        
        function disp0(obj)
            fprintf(['component #%d:\n', ...
                     '\t name = %s\n', ...
                     '\t type = %s\n', ...
                     '\t option = %s\n', ...
                     '\t freq. = %7.5e\n', ...
                     '\n'], ...
                     obj.index, obj.name, obj.type, obj.option, obj.frequency);
        end
    end
    
end

