clear;clc;

import Condition.Coil
import Atom.AlkaliMetal
import Gas.VaporGas
import Laser.AlkaliLaserBeam
import CellSystem.VaporCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.00001), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.00003)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={  VaporGas(rb85, 'vapor', temperature, Atom.Transition.D1), ...
         VaporGas(rb87, 'vapor', temperature, Atom.Transition.D1) ...
         };

pumpBeam=AlkaliLaserBeam(0.25e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, -3064,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size
                     

%%
t_pump = 10.0;
sys=VaporCell(gases, pumpBeam.set_detuning(-1400));

sys.interaction{1, 2}.parameter.v_sampling.nRaw=16;
sys.interaction{1, 3}.parameter.v_sampling.nRaw=16;

beam_index = 1; vapor_index = 3;
data=sys.velocity_resolved_pumping(beam_index, vapor_index, t_pump);

F1pop=sum(data.popG(6:8, :), 1); F2pop=sum(data.popG(1:5, :), 1);
F1gm=sum(data.gammaG_diag(6:8, :), 1); F2gm=sum(data.gammaG_diag(1:5, :), 1);

figure;
subplot(3, 2, 1); plot(data.vList, F1pop, 'ro-', data.vList, F2pop, 'bd-'); ylim([0 1])
subplot(3, 2, 3); semilogy(data.vList, F1gm, 'ro-',data.vList, F2gm, 'bd-')
subplot(3, 2, 5); plot(data.vList, sum(data.popG.*data.gammaG_diag,1), 'ko-', data.vList, data.absorption, 'rd-')

subplot(3, 2, 2);plot(data.vList, data.uList, 'ro-')
subplot(3, 2, 4);plot(data.vList, (F1pop.*F1gm + F2pop.*F2gm).*data.uList', 'ko-')
subplot(3, 2, 6);plot(data.vList,  data.absorption.*data.uList', 'ko-')
