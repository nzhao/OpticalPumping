clear;clc;

import Condition.Coil
import Atom.* Atom.Buffer.* VaporCell.*
import Laser.AlkaliLaserBeam

%% System
coil = { ... 
    Condition.Coil('coilx', 0.0), ...
    Condition.Coil('coily', 0.0), ...
    Condition.Coil('coilz', 0.0001)};

rb85=AlkaliMetal('85Rb', coil);
rb87=AlkaliMetal('87Rb', coil);

temperature=273.15+20;
gases={ ...
    Gas(rb85, 'vapor', temperature), ...
    Gas(rb87, 'vapor', temperature)
};

ensemble=MixedGas(gases);

pumpBeam=AlkaliLaserBeam(1e-3, ...                     % power in [W]
                         rb85, Atom.Transition.D1, -2.25e3, ... % ref Atom 
                         [0 0 1], [1, 0], 2e-3);       % direction, pol, spot size

%% debug AlkaliOpticalMatrix
mat=VaporCell.AlkaliOpticalMatrix(gases{2}, pumpBeam);
ker=mat.qsG;
rho=rb87.equilibrium_state(Atom.Transition.D1)
lg=logical(rho.getQuasiSteadyStateCol());
col=zeros(128,1);
col(1)=1;
col=rho.getQuasiSteadyStateCol();
t=linspace(0,10,101);
res=zeros(8, length(t));
for k=1:length(t)
col1 = expm(-ker*t(k))*col;
res(:,k)=col1(lg);
end
plot(t,res)

%% cross section
detune = linspace(-6e3, 6e3, 301);
absorption_det85 = zeros(1, length(detune));
absorption_det87 = zeros(1, length(detune));
for k = 1:length(detune)
    pumpBeam.set_power(1e-6).set_detuning(detune(k)) ;
    sys=System.OpticalPumping(ensemble, pumpBeam);
    absorption_det85(k) = sys.gases.optical_pumping{1}.absorption_cross_section0;
    absorption_det87(k) = sys.gases.optical_pumping{2}.absorption_cross_section0;
end

cell_length = 0.020; %m
OD85 = gases{1}.density*absorption_det85*cell_length;
OD87 = gases{2}.density*absorption_det87*cell_length;

%% plot
subplot(1,2,1)
plot(detune/1e3,  OD85, 'b--', detune/1e3,  OD87, 'r--', detune/1e3, OD85+OD87, 'k-' )
subplot(1,2,2)
plot(detune/1e3, exp(-OD85), 'b--', detune/1e3,  exp(-OD85), 'r--', detune/1e3, exp(-OD85-OD87), 'k-' )
ylim([0,1.2])