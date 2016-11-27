clear;clc;

import Condition.Coil
import Atom.AlkaliMetal
import Gas.Gas
import Laser.AlkaliLaserBeam
import CellSystem.VacuumCell

%% Ingredients
coil = { ... 
    Condition.Coil('coilx', 0.0000001), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.0000003)};

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
nf = 1512; width = 250;
freq1 = -3070; freq2 = -2260;
freq3 = 3765; freq4 = 4575;

[gammaG1, diag1, freqList1, weight1, area1] = sweep_resonance(freq1, width, nf, gases, pumpBeam);
[gammaG2, diag2, freqList2, weight2, area2] = sweep_resonance(freq2, width, nf, gases, pumpBeam);
[gammaG3, diag3, freqList3, weight3, area3] = sweep_resonance(freq3, width, nf, gases, pumpBeam);
[gammaG4, diag4, freqList4, weight4, area4] = sweep_resonance(freq4, width, nf, gases, pumpBeam);


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

area = [area1 area2 area3 area4];
tV = Interaction.AtomPhotonInteraction( gases{2}, pumpBeam );
ratio = sum(area, 2)./diag(tV'*tV);

int_sigma = sum(2*pi*sum(area, 2))/8 *1e12 / pumpBeam.photonFlux / 4; 
analyitic_val = pi*c_velocity*r_e*rb87.parameters.osc_1;
disp(area);
disp(tV);
disp(ratio);
disp([int_sigma, analyitic_val]);