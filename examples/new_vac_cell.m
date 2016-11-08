clear;clc;

import Condition.Coil
import Atom.AlkaliMetal
import Gas.Gas
import Laser.AlkaliLaserBeam
import CellSystem.VacuumCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.0), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.0001)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={ ...
    Gas(rb85, 'vapor', temperature), ...
    Gas(rb87, 'vapor', temperature) ...
};

pumpBeam=AlkaliLaserBeam(5e-3, ...                     % power in [W]
                         rb85, Atom.Transition.D1, -2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size
                     
%% System

sys=VacuumCell(gases, pumpBeam);