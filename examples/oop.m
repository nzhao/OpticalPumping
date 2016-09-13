clear;clc;

import Condition.Coil
import Atom.* Atom.Buffer.* VaporCell.*
import Laser.AlkaliLaserBeam

coil=Condition.Coil('coil');
coil.set_magB(0.2);

rb=AlkaliMetal('87Rb', coil);
n2=Nitrogen();
he4=He4();

temperature=273.15+25;
gases={ ...
    Gas(rb, 'vapor', temperature), ... 
    Gas(n2, 'buffer', temperature, 1.e4, 'N2'), ...
    Gas(he4, 'buffer', temperature, 5.e4, '4He') ...
};

ensemble=MixedGas(gases);

pumpBeam=AlkaliLaserBeam(0.001, ...                     % power in [W]
                         rb, Atom.Transition.D1, 0, ... % ref Atom 
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size

sys=System.OpticalPumping(ensemble, pumpBeam);
sys.evolve(500.0, 301);

sys.calc_observable();

subplot(1,2,1)
plot(sys.result.time, sys.result.observable.mean_spin, 'd-')
subplot(1,2,2)
plot(sys.result.time, sys.result.observable.population, '*-')
