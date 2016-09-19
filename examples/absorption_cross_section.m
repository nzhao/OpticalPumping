clear;clc;

import Condition.Coil
import Atom.* Atom.Buffer.* VaporCell.*
import Laser.AlkaliLaserBeam

%% System
coil = { ... 
    Condition.Coil('coilx', 0.0), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.0001)};

rb=AlkaliMetal('87Rb', coil);
n2=Nitrogen();
he4=He4();

temperature=350;
gases={ ...
    Gas(rb, 'vapor', temperature), ... 
    Gas(n2, 'buffer', temperature, 50*Torr2Pa, 'N2'), ...
    Gas(he4, 'buffer', temperature, 700*Torr2Pa) ...
};

ensemble=MixedGas(gases);

pumpBeam=AlkaliLaserBeam(1e-5, ...                     % power in [W]
                         rb, Atom.Transition.D1, 0, ... % ref Atom 
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size

%% absorption vs. detuning

detune = linspace(-100e3, 100e3, 21);
absorption = zeros(1, length(detune));
for k = 1:length(detune)
    fprintf('detuning = %f\n', detune(k));
    pumpBeam.detune = detune(k);
    sys=System.OpticalPumping(ensemble, pumpBeam);
    obs = sys.gases.optical_pumping{1}.effective_Gamma;
    
    tau = 1e-2 / sys.gases.optical_pumping{1}.gamma_p;
    %tau = 5;
    state = sys.steady_state(tau, inf, 1e-8);
    absorption(k) = state{1}.mean(obs);
end
figure;
plot(detune, absorption* 2*pi*1e6 / pumpBeam.photonFlux * 1e4, 'rd-')

%% absorption vs. detuning

power = logspace(-6, -2, 25);
absorption_power = zeros(1, length(power));
for k = 1:length(power)
    fprintf('power = %f\n', power(k));
    pumpBeam=AlkaliLaserBeam(power(k), ...                     % power in [W]
                             rb, Atom.Transition.D1, 0, ... % ref Atom 
                             [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size
    sys=System.OpticalPumping(ensemble, pumpBeam);
    obs = sys.gases.optical_pumping{1}.effective_Gamma;
    
    tau = 1e-2 / sys.gases.optical_pumping{1}.gamma_p;
    %tau = 5;
    state = sys.steady_state(tau, inf, 1e-8);
    absorption_power(k) = state{1}.mean(obs);
end
figure;
semilogx(power, absorption_power* 2*pi*1e6 / pumpBeam.photonFlux * 1e4, 'rd-')
