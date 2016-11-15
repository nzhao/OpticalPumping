function pressureBroadening( obj, gases )
%SET_GAMMA2 Summary of this function goes here
%   Detailed explanation goes here
    obj.gamma2 = 0;
    for q=1:length(gases)
        gas=gases{q};
        atom_pair = [obj.name, '-', gas.name];
        switch atom_pair
            case '87Rb-N2'
                gamma2_q = 19e3 * gas.density / (amagat*1e6);
            case '87Rb-4He'
                gamma2_q = 18e3 * gas.density / (amagat*1e6);
            case '133Cs-N2'
                gamma2_q = 16e3 * gas.density / (amagat*1e6);
            case '133Cs-4He'
                gamma2_q = 23e3 * gas.density / (amagat*1e6);
            otherwise
                gamma2_q=0;
                %warning('atom pair (%s, %s) not supported. Pressure broadening is set to zero.', obj.name, gas.name);
        end
        obj.gamma2 = obj.gamma2 + gamma2_q;
    end
end

