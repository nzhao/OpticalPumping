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

pumpBeam=AlkaliLaserBeam(0.25e-6, ...                     % power in [W]
                         rb87, Atom.Transition.D1, -3064,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size
                     

%%
df = 0.2; width = 50;
freq1 = -3070; freq2 = -2260;
freq3 = 3765; freq4 = 4575;

[gammaG1, diag1, freqList1] = sweep_resonance(freq1, width, df, gases, pumpBeam);
[gammaG2, diag2, freqList2] = sweep_resonance(freq2, width, df, gases, pumpBeam);
[gammaG3, diag3, freqList3] = sweep_resonance(freq3, width, df, gases, pumpBeam);
[gammaG4, diag4, freqList4] = sweep_resonance(freq4, width, df, gases, pumpBeam);


subplot(2, 2, 1)
plot(freqList1, diag1, '*-')
legend('s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8');

subplot(2, 2, 2)
plot(freqList2, diag2, '*-')
legend('s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8');

subplot(2, 2, 3)
plot(freqList3, diag3, '*-')
legend('s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8');

subplot(2, 2, 4)
plot(freqList4, diag4, '*-')
legend('s1', 's2', 's3', 's4', 's5', 's6', 's7', 's8');

%%

area = df* [sum(diag1, 2) sum(diag2, 2) sum(diag3, 2) sum(diag4, 2)];
tV = Interaction.AtomPhotonInteraction( gases{2}, pumpBeam );
ratio = sum(area, 2)./diag(tV'*tV);

disp(area);
disp(tV);
disp(ratio);