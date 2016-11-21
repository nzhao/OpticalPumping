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

radius = 2e-3;
pumpBeam=AlkaliLaserBeam(1e-8, ...                     % power in [W]
                         rb, Atom.Transition.D1, 0, ... % ref Atom 
                         [0 0 1], [1, 1i], radius);       % direction, pol, spot size
                     
%% analytisis
temperature_T = linspace(273, 373, 6);
power = logspace(-8, -1, 50);
intensity_out = zeros(length(temperature_T), length(power));
OD_out = zeros(length(temperature_T), length(power));
for q = 1:length(temperature_T)
    for k = 1:length(power)
        pumpBeam.set_detuning(0).set_power(power(k));
        ensemble.set_temperature( temperature_T(q) );
        
        sys=System.OpticalPumping(ensemble, pumpBeam );
        sigma0 = sys.gases.optical_pumping{1}.absorption_cross_section0;
        OD = sys.gases.gasList{1}.density * sigma0 * 0.020;

        gamma_p=sys.gases.optical_pumping{1}.gamma_p * 2*pi*1e6;
        gamma_sd=sum(sys.gases.spin_destruction(1,:)) * 2*pi*1e6;
        
        sd_intensity = pumpBeam.photonEnergy* gamma_sd / sigma0 * pi*radius^2;
        x = gamma_p/gamma_sd;
        intensity_out(q, k) = power(k) * lambertw(x*exp(x-OD)) / x;
        OD_out(q, k) = log(power(k)/ intensity_out(q, k));
    end
end

%% plot
legendCell = cellstr(num2str((temperature_T-273)', 'temperature = %d'));

subplot(1, 2, 1)
loglog(power, intensity_out)
grid on
title('detuning = 0')
xlabel('input power (W)')
ylabel('output power (W)')
legend(legendCell,'Location','southeast');

subplot(1, 2, 2)
loglog(power, OD_out)
grid on
title('detuning = 0')
xlabel('input power (W)')
ylabel('OD')
legend(legendCell,'Location','southwest');
