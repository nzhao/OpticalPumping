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

rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={  Gas(rb87, 'vapor', temperature, Atom.Transition.D1) };

pumpBeam=AlkaliLaserBeam(5e-4, ...                     % power in [W]
                         rb87, Atom.Transition.D1, 4580,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size
                     
%% System
t_inf = 2e1;
freqList = linspace(3.0e3, 5e3, 51);
popG=zeros(8, length(freqList));
cross_section=zeros(1, length(freqList));
for k=1:length(freqList)
    freq = freqList(k);
    fprintf('freq = %f\n', freq);
    sys=VacuumCell(gases, pumpBeam.set_detuning(freq));
    [state_freq, ~, cross_section(k)] = sys.evolution(2, t_inf, 'DopplerAverage');
    popG(:, k) = state_freq.population(2);
end
figure;
subplot(2, 1, 1)
plot(freqList, sum(popG(6:8, :), 1), 'r*-', freqList,  sum(popG(1:5, :), 1), 'bd-')
subplot(2, 1, 2)
plot(freqList, cross_section, 'bd-')


%%

timeList = linspace(0, 1e4, 101);
popG_t=zeros(8, length(timeList));
popE_t=zeros(8, length(timeList));
sys=VacuumCell(gases, pumpBeam.set_detuning(4575));
sys.interaction{1, 2}.calc_matrix();
for k=1:length(timeList)
    t=timeList(k);
    fprintf('time = %f\n', t);
    state_t=sys.evolution(2, t);
    popE_t(:,k)=state_t.population(1);
    popG_t(:,k)=state_t.population(2);
end
figure;
subplot(1,3,1)
plot(timeList,popE_t)
subplot(1,3,2)
plot(timeList,popG_t)
subplot(1,3,3)
plot(timeList,sum(popG_t,1)+sum(popE_t, 1))
