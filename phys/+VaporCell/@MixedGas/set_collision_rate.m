function set_collision_rate( obj )
%PUMPING_RATIO Summary of this function goes here
%   Detailed explanation goes here
    nGas = length(obj.gasList);

    obj.spin_destruction = zeros(nGas);
    obj.spin_exchange = zeros(nGas);
    obj.spin_rotation = zeros(nGas);

    for k=1:nGas
        for q=1:nGas
            obj.spin_destruction(k,q) = obj.SDRate(obj.gasList{k}, obj.gasList{q});
            obj.spin_exchange(k,q) = obj.SERate(obj.gasList{k}, obj.gasList{q});
            obj.spin_rotation(k,q) = obj.SRRate(obj.gasList{k}, obj.gasList{q});
        end
    end

end

