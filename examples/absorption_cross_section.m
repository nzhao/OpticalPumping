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

temperature=373;
gases={ ...
    Gas(rb, 'vapor', temperature), ... 
    Gas(n2, 'buffer', temperature, 50*Torr2Pa, 'N2'), ...
    Gas(he4, 'buffer', temperature, 700*Torr2Pa) ...
};

ensemble=MixedGas(gases);

pumpBeam=AlkaliLaserBeam(1e-3, ...                     % power in [W]
                         rb, Atom.Transition.D1, 0, ... % ref Atom 
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size

%% absorption vs. detuning
detune = linspace(-10e3, 10e3, 101);
absorption_det = zeros(1, length(detune));
for k = 1:length(detune)
    fprintf('detuning = %f\n', detune(k));
    pumpBeam.set_power(1e-6).set_detuning(detune(k)) ;
    sys=System.OpticalPumping(ensemble, pumpBeam);
    obs = sys.gases.optical_pumping{1}.effective_Gamma* 2*pi*1e6;
    
    tau = 1e-3 / sys.gases.optical_pumping{1}.gamma_p;
    state = sys.steady_state(tau, inf, 1e-6);
    absorption_det(k) = state{1}.mean(obs) / pumpBeam.photonFlux * 1e4;
end

%% absorption vs. power
power = logspace(-9, -1, 35);
absorption_power = zeros(1, length(power));
for k = 1:length(power)
    fprintf('power = %f\n', power(k));
    pumpBeam.set_detuning(0).set_power(power(k));
    sys=System.OpticalPumping(ensemble, pumpBeam );
    obs = sys.gases.optical_pumping{1}.effective_Gamma* 2*pi*1e6;
    
    tau = 1e-3 / sys.gases.optical_pumping{1}.gamma_p;
    state = sys.steady_state(tau, inf, 1e-6);
    absorption_power(k) = state{1}.mean(obs) / pumpBeam.photonFlux * 1e4;
end

%% analytisis

absorption_power_analytic = zeros(1, length(power));
intensity_out = zeros(1, length(power));
for k = 1:length(power)
    pumpBeam.set_detuning(0).set_power(power(k));
    sys=System.OpticalPumping(ensemble, pumpBeam );
    sigma0 = sys.gases.optical_pumping{1}.absorption_cross_section0;
    OD = sys.gases.gasList{1}.density * sigma0 * 0.020;
    
    gamma_p=sys.gases.optical_pumping{1}.gamma_p;
    gamma_sd=sum(sys.gases.spin_destruction(1,:));
    x = gamma_p/gamma_sd;
    absorption_power_analytic(k) = sigma0 / (1 + x) * 1e4;
    intensity_out(k) = power(k) * lambertw(x*exp(x-OD)) / x;
end

%% plot
figure;
subplot(2, 2, 1)
plot(detune*1e-3, absorption_det, 'rd-')
grid on
title('Power = 10^{-6} W')
xlabel('detuning (GHz)')
ylabel('absorption cross section (cm^{-2})')

subplot(2, 2, 2)
semilogx(power, absorption_power, 'bo', power, absorption_power_analytic, 'b-')
grid on
title('detuning = 0')
xlabel('power (W)')
ylabel('absorption cross section (cm^{-2})')

subplot(2, 2, 3)
loglog(power, intensity_out, 'bo-')
grid on
title('detuning = 0')
xlabel('power (W)')
ylabel('power (W)')

subplot(2, 2, 4)
semilogx(power, log(power./intensity_out), 'bo-')
grid on
title('detuning = 0')
xlabel('power (W)')
ylabel('OD')
