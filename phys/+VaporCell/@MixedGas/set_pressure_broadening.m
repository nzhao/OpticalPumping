function set_pressure_broadening( obj )
%SET_PRESSURE_BROADENING Summary of this function goes here
%   Detailed explanation goes here
    nGas = length(obj.gasList);
    for k=1:nGas
        for q=1:nGas
            obj.gasList{k}.pressureBroadening(obj.gasList{q});
        end
    end
end

