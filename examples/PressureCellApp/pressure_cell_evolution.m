clear;clc;

import Condition.Coil
import Atom.AlkaliMetal 
import Atom.Buffer.Nitrogen
import Atom.Buffer.He4
import Gas.VaporGas Gas.BufferGas
import Laser.AlkaliLaserBeam
%import CellSystem.VacuumCell
import CellSystem.VaporCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.00000), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.00003)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);
n2=Nitrogen();
he4=He4();

temperature=273.15+70;
gases={  VaporGas(rb85, 'vapor', temperature, Atom.Transition.D1), ...
         VaporGas(rb87, 'vapor', temperature, Atom.Transition.D1) ...
         BufferGas(n2, temperature, 50*Torr2Pa, 'N2'), ...
         BufferGas(he4, temperature, 700*Torr2Pa) ...
         };

pumpBeam_lin=AlkaliLaserBeam(300e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, -2.25e3,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 4e-3);       % direction, pol, spot size
                     
pumpBeam_cir=AlkaliLaserBeam(300e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, -2.25e3,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, -1i], 4e-3);       % direction, pol, spot size

t_pump = 1e4;
%% approximation ground state pumping

sysApproxGS_lin=VaporCell(gases, pumpBeam_lin, 'high-pressure');
sysApproxGS_cir=VaporCell(gases, pumpBeam_cir, 'high-pressure');

freqList=-150e3:2000:150e3;  beam_index = 1;
res_absorption_lin=sysApproxGS_lin.total_absorption_cross_section(beam_index, freqList, t_pump);
res_absorption_cir=sysApproxGS_cir.total_absorption_cross_section(beam_index, freqList, t_pump);

figure;plot(freqList, sum(res_absorption_lin, 1), 'rd-', freqList, sum(res_absorption_cir, 1), 'b*-')

% timeList = linspace(0, 5e4, 101);
% state=sysApproxGS_cir.evolution(3, timeList);
% popG = cell2mat(cellfun(@(s)  s.population(2), state, 'UniformOutput', false));
% figure;plot(timeList, popG)