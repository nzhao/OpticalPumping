function r = SDRate( obj, gas1, gas2 )
%SDRATIO Summary of this function goes here
%   Detailed explanation goes here
    atom_pair = [gas1.name, '-', gas2.name];
    
    v = sqrt(gas1.velocity^2 + gas2.velocity^2);
    switch atom_pair
        case '87Rb-87Rb'
            cross_section=1.6e-17;
        case '87Rb-N2'
            cross_section=1.0e-22;
        case '87Rb-4He'
            cross_section=9e-24;
        
        case '133Cs-133Cs'
            cross_section=2.0e-16;
        case '133Cs-N2'
            cross_section=5.50e-22;
        case '133Cs-4He'
            cross_section=2.8e-23;
        otherwise
            cross_section=0;
            %warning('atom pair (%s, %s) not supported. damping ratio is set to zero.', gas1.atom.name, gas2.atom.name);
    end
    r = cross_section*1e-4 * v * gas2.density /( 2*pi*1e6); % MHz

end

