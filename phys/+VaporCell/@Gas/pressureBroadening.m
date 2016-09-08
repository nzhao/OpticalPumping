function pressureBroadening( obj, gas )
%SET_GAMMA2 Summary of this function goes here
%   Detailed explanation goes here

    atom_pair = [obj.atom.name, '-', gas.atom.name];
    switch atom_pair
        case '87Rb-87Rb'
            obj.gamma2=0.1;
        case '87Rb-133Cs'
            obj.gamma2=0.1;
        case '133Cs-87Rb'
            obj.gamma2=0.1;
        case '133Cs-133Cs'
            obj.gamma2=0.1;
        otherwise
            obj.gamma2=0;
            obj.warning('atom pair (%s, %s) not supported. Pressure broadening is set to zero.', gas1.atom.name, gas2.atom.name);
    end
end

