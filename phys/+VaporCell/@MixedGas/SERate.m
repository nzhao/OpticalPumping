function r = SERate( obj, gas1, gas2 )
%SDRATIO Summary of this function goes here
%   Detailed explanation goes here
    atom_pair = [gas1.name, '-', gas2.name];
    
    v = sqrt(gas1.velocity^2 + gas2.velocity^2);
    switch atom_pair
        case '87Rb-87Rb'
            cross_section = 1.9e-14; % cm^2
        case '133Cs-133Cs'
            cross_section = 2.1e-14;
        otherwise
            cross_section = 0;
            %warning('atom pair (%s, %s) not supported. exchange ratio is set to zero.', gas1.atom.name, gas2.atom.name);
    end
    r = cross_section*1e-4 * v * gas2.density /( 2*pi*1e6); % MHz

end

