clear;clc;

import Condition.Coil
import Atom.* Atom.Buffer.* VaporCell.*
import Laser.AlkaliLaserBeam

%% System
coil = { ... 
    Condition.Coil('coilx', 0.0), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.0001)};

rb=AlkaliMetal('87Rb', coil);

temperature=373;
gases={ ...
    Gas(rb, 'vapor', temperature)

};

ensemble=MixedGas(gases);

pumpBeam=AlkaliLaserBeam(1e-3, ...                     % power in [W]
                         rb, Atom.Transition.D1, 2.2594e3, ... % ref Atom 
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size
%% Test
detune = linspace(-10e3, 10e3, 501);
absorption_det = zeros(1, length(detune));
for k = 1:length(detune)
    pumpBeam.set_power(1e-6).set_detuning(detune(k)) ;
    sys=System.OpticalPumping(ensemble, pumpBeam);
    absorption_det(k) = sys.gases.optical_pumping{1}.absorption_cross_section0;
end
plot(detune, absorption_det)