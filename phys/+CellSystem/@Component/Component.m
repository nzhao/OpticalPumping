classdef Component < handle
    %COMPONENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        index
        name
        type
        stuff
        state
        steady_state
        option
        frequency
    end
    
    methods
        function obj = Component(idx, stuff, state, option)
            obj.index = idx;
            obj.stuff = stuff;
            obj.name = stuff.name;
            obj.type = stuff.type;
            if nargin < 3
                state = [];
            end
            if nargin < 4
                option = '';
            end
            
            obj.state = state;            
            obj.option = option; 
            obj.steady_state = [];
        end
        
        function freq = set_frequency(obj, varargin)
            if strcmp(obj.type, 'beam')
                freq = obj.stuff.frequency;
            elseif strcmp(obj.type, 'vapor')
                beam = varargin{1};
                atom = obj.stuff.atom;
                freq = atom.parameters.omega(beam.refTransition)/2/pi;
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

