clear;clc;

import Condition.Coil
import Atom.* Atom.Buffer.* VaporCell.*
import Laser.AlkaliLaserBeam

%% System
coil = { ... 
    Condition.Coil('coilx', 0.0000), ...
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

pumpBeam=AlkaliLaserBeam(1e-4, ...                     % power in [W]
                         rb, Atom.Transition.D1, 0, ... % ref Atom 
                         [0 0 1], [1, 1i], 2e-3);       % direction, pol, spot size

sys=System.OpticalPumping(ensemble, pumpBeam);
sys.evolve(50000.0, 1001);

%% Observable
density_matrix = sys.get_state(1);

obs1=containers.Map();
obs1('sx') = rb.matEigen.Smat{1}(:,:,1);
obs1('sy') = rb.matEigen.Smat{1}(:,:,2);
obs1('sz') = rb.matEigen.Smat{1}(:,:,3);
spin_component=System.calc_obs( density_matrix, obs1 );

obs2=containers.Map();
for k = 1:rb.dim(Atom.Subspace.GS)
    obs2(['p' num2str(k)]) = rb.proj_op(k);
end
level_population=System.calc_obs( density_matrix, obs2 );

obs3=containers.Map();
obs3('gamma_p') = sys.gases.optical_pumping{1}.effective_Gamma;
abs_cross_sec=System.calc_obs( density_matrix, obs3 );


%% Plot
figure;
subplot(2,2,1)
System.plot_obs(sys.result.time*1e-6, spin_component, {'+r-', 'xg-', 'ob-'});

subplot(2,2,2)
System.plot_obs(sys.result.time*1e-6, level_population, {'r.-', 'g.-', 'b.-'});

subplot(2,2,3)
System.plot_obs(sys.result.time*1e-6, abs_cross_sec, {'r.-'}, @semilogy);
