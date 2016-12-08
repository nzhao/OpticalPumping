clear;clc;

import Condition.Coil
import Atom.AlkaliMetal 
import Atom.Buffer.Nitrogen
import Atom.Buffer.He4
import Gas.Gas Gas.BufferGas
import Laser.AlkaliLaserBeam
import CellSystem.VacuumCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.00001), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.00003)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);
n2=Nitrogen();
he4=He4();

temperature=273.15+20;
gases={  Gas(rb85, 'vapor', temperature, Atom.Transition.D1), ...
         Gas(rb87, 'vapor', temperature, Atom.Transition.D1) ...
         BufferGas(n2, temperature, 50*Torr2Pa, 'N2'), ...
         BufferGas(he4, temperature, 700*Torr2Pa) ...
         };

pumpBeam=AlkaliLaserBeam(500e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, 4575,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size

%% approximation ground state pumping

sysApproxGS=VacuumCell(gases, pumpBeam, 'vacuum-ground');