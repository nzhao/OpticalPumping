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
freq1 = -3050; freq2 = -2250;
freq3 = 3750; freq4 = 4600;

freqK = freq1;
freqList = freqK-50:0.1:freqK+30;
%freqList = -6e3:100:5e3;
gammaG = zeros(8, 8, length(freqList));
for k=1:length(freqList)
    fprintf('freq = %f\n', freqList(k));
    sys=VacuumCell(gases, pumpBeam.set_detuning(freqList(k)));
    mat = sys.velocity_resolved_GammaG(3, 0);
    gammaG(:,:,k) = mat{1};
end
inteGammaG=50*sum(gammaG, 3);
%% 
g=zeros(8, length(freqList));
for k=1:8
    g(k, :) = reshape(gammaG(k, k, :), [1 length(freqList)])+k*1e-4;
end
plot(freqList, g, '*-')


