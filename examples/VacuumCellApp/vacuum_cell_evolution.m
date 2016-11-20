clear;clc;

import Condition.Coil
import Atom.AlkaliMetal
import Gas.Gas
import Laser.AlkaliLaserBeam
import CellSystem.VacuumCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.00001), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.00003)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={  Gas(rb85, 'vapor', temperature, Atom.Transition.D1), ...
         Gas(rb87, 'vapor', temperature, Atom.Transition.D1) ...
         };

pumpBeam=AlkaliLaserBeam(5e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, -3064,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size
                     
%%
timeList = linspace(0, 50.0, 101);
sys=VacuumCell(gases, pumpBeam.set_detuning(4575).set_power(5e-6));
sys.interaction{1, 3}.calc_matrix();
states=sys.evolution(3, timeList);

popE_t = cell2mat(cellfun(@(s)  s.population(1),       states, 'UniformOutput', false));
popG_t = cell2mat(cellfun(@(s)  s.population(2),       states, 'UniformOutput', false));
cohE_t = cell2mat(cellfun(@(s)  s.max_coherence(1),    states, 'UniformOutput', false));
cohG_t = cell2mat(cellfun(@(s)  s.max_coherence(2),    states, 'UniformOutput', false));
cohEG_t = cell2mat(cellfun(@(s) s.max_coherence(1, 2), states, 'UniformOutput', false));

figure;
subplot(2,3,1); plot(timeList,popE_t)
subplot(2,3,2); plot(timeList,popG_t)
subplot(2,3,3); plot(timeList,sum(popG_t,1)+sum(popE_t, 1))

subplot(2,3,4);plot(timeList,cohE_t)
subplot(2,3,5);plot(timeList,cohG_t)
subplot(2,3,6);plot(timeList,cohEG_t)
