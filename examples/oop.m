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

pumpBeam=AlkaliLaserBeam(0.1, ...                       % power in [W]
                         rb, Atom.Transition.D1, 0, ... % ref Atom 
                         [0 0 1], [1, 1i], 1e-3);       % direction, pol, spot size

sys=System.OpticalPumping(ensemble, pumpBeam);
sys.evolve(10.0, 101);

sys.calc_observable();
plot(sys.result.time, sys.result.observable, 'd-')