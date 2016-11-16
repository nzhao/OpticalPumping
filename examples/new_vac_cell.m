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
                         rb87, Atom.Transition.D1, -3064,...%-2.25e3, ... % ref Atom 
                         [0 0 1], [1, -1i], 2e-3);       % direction, pol, spot size
                     

%%
t_pump = 50.0;
sys=VacuumCell(gases, pumpBeam.set_detuning(-1000));
vData=sys.velocity_resolved_pumping(2, t_pump, 'diagnose');

%% System
freqList = linspace(-5.0e3, 6e3, 151);
abs_res=zeros(1, length(freqList));
for k=1:length(freqList)
    freq = freqList(k); fprintf('freq = %f\n', freq);
    sys=VacuumCell(gases, pumpBeam.set_detuning(freq));
    abs_res(k) = sys.absorption_cross_section(2, t_pump);
end
figure;
plot(freqList, abs_res, 'r*-')


%%

timeList = linspace(0, 1.0, 101);
popG_t=zeros(8, length(timeList));
popE_t=zeros(8, length(timeList));
cohG_t=zeros(1, length(timeList));
cohE_t=zeros(1, length(timeList));
cohEG_t=zeros(1, length(timeList));
sys=VacuumCell(gases, pumpBeam.set_detuning(4575).set_power(5e-4));
sys.interaction{1, 2}.calc_matrix();
for k=1:length(timeList)
    t=timeList(k);
    fprintf('time = %f\n', t);
    state_t=sys.evolution(2, t);
    popE_t(:,k)=state_t.population(1);
    popG_t(:,k)=state_t.population(2);
    cohE_t(k) = state_t.max_coherence(1);
    cohG_t(k) = state_t.max_coherence(2);
    cohEG_t(k) = state_t.max_coherence(1, 2);
end
figure;
subplot(2,3,1)
plot(timeList,popE_t)
subplot(2,3,2)
plot(timeList,popG_t)
subplot(2,3,3)
plot(timeList,sum(popG_t,1)+sum(popE_t, 1))

subplot(2,3,4)
plot(timeList,cohE_t)
subplot(2,3,5)
plot(timeList,cohG_t)
subplot(2,3,6)
plot(timeList,cohEG_t)
