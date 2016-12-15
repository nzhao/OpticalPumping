function gamma2 = PressureBroadening( gas1, gas2 )
%PRESSUREBROADENING Summary of this function goes here
%   Detailed explanation goes here
    atom_pair = [gas1.name, '-', gas2.name];
    switch atom_pair
        case {'87Rb-N2', '85Rb-N2'}
            gamma2 = 19e3 * gas2.density / (amagat*1e6);
        case {'87Rb-4He', '85Rb-4He'}
            gamma2 = 18e3 * gas2.density / (amagat*1e6);
        case '133Cs-N2'
            gamma2 = 16e3 * gas2.density / (amagat*1e6);
        case '133Cs-4He'
            gamma2 = 23e3 * gas2.density / (amagat*1e6);
        otherwise
            gamma2=0;
            %warning('atom pair (%s, %s) not supported. Pressure broadening is set to zero.', obj.name, gas.name);
    end
end

