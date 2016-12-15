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
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size

t_pump = 1e4;
%% approximation ground state pumping
freqList=-50e3:500:50e3;
sysApproxGS=VacuumCell(gases, pumpBeam, 'vacuum-ground');
res_absorption=sysApproxGS.total_absorption_cross_section(freqList, t_pump);
figure;plot(freqList, sum(res_absorption, 1))

timeList = linspace(0, 5e4, 101);
state=sysApproxGS.evolution(3, timeList);
popG = cell2mat(cellfun(@(s)  s.population(2), state, 'UniformOutput', false));
figure;plot(timeList, popG)