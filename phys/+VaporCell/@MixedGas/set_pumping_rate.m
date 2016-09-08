function set_pumping_rate( obj, beam )
%SET_PUMPING_RATE Summary of this function goes here
%   Detailed explanation goes here
    obj.optical_pumping = cell(size(obj.gasList));
    for k=1:length(obj.gasList)
        gas_k = obj.gasList{k};
        obj.optical_pumping{k} = gas_k.highPressurePumping(beam);
    end

end

