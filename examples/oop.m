clear;clc;

import Condition.Coil
import Atom.* Atom.Buffer.* VaporCell.*
import Laser.AlkaliLaserBeam

coilz=Condition.Coil('coilz', 0.0001);
coilx=Condition.Coil('coilx', 0.00001);
coily=Condition.Coil('coily', 0.0);

rb=AlkaliMetal('87Rb', {coilx, coily, coilz});
n2=Nitrogen();
he4=He4();

temperature=350;
gases={ ...
    Gas(rb, 'vapor', temperature), ... 
    Gas(n2, 'buffer', temperature, 50*Torr2Pa, 'N2'), ...
    Gas(he4, 'buffer', temperature, 700*Torr2Pa) ...
};

ensemble=MixedGas(gases);

pumpBeam=AlkaliLaserBeam(0.001, ...                     % power in [W]
                         rb, Atom.Transition.D1, 0, ... % ref Atom 
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size

sys=System.OpticalPumping(ensemble, pumpBeam);
sys.evolve(5000.0, 1001);

sys.calc_observable();

pop = real(sys.result.observable.population(:,end));
ratio = rb.pop_ratio(pop);



subplot(1,2,1)
plot(sys.result.time, sys.result.observable.mean_spin, 'd-')
subplot(1,2,2)
plot(sys.result.time, sys.result.observable.population, '*-')
