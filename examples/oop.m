clear;clc;

import Condition.Coil
import Atom.AlkaliMetal Atom.Noble Atom.Buffer.Nitrogen Atom.Buffer.He4
import VaporCell.Gas VaporCell.MixedGas
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

pumpBeam=AlkaliLaserBeam(0.1, rb, Atom.Transition.D1, 0, ...
                               [0 0 1], [1, 1i], 1e-3);

sys=System.OpticalPumping(ensemble, pumpBeam);
sys.evolve(1.0, 101);