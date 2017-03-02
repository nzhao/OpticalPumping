function sigma_v = dopplerBroadening( obj )
%DOPPLERBROADENING Summary of this function goes here
%   Detailed explanation goes here
    m = obj.atom.parameters.mass * 1e-3; % kg
    sigma_v = sqrt(kB*obj.temperature*avogadro/m);
end

