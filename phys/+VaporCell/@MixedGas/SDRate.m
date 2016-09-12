function r = SDRate( obj, gas1, gas2 )
%SDRATIO Summary of this function goes here
%   Detailed explanation goes here
    atom_pair = [gas1.atom.name, '-', gas2.atom.name];
    switch atom_pair
        case '87Rb-87Rb'
            r=0.0;
        case '87Rb-133Cs'
            r=0.0;
        case '133Cs-87Rb'
            r=0.0;
        case '133Cs-133Cs'
            r=0.0;
        otherwise
            r=0;
            %warning('atom pair (%s, %s) not supported. damping ratio is set to zero.', gas1.atom.name, gas2.atom.name);
    end

end

