function rate = SelfSERate( atom, condition )
%SELFSERATE Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants;

    rate.shift = 0;
    
    thermal_v = sqrt(kB*condition.temperature*NA/atom.pm.MW); % cm/s, v=Eq(6.111)
    cross_section = atom.SE_cross_section;
    density = condition.density;
    
    se = density*thermal_v*cross_section * 1e-6;
    rate.damping = se;
    rate.exchange = se;
end

