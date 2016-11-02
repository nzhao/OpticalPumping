clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'

%% Laser Beam
power=100.0/(pi*0.1^2);       %0.00001; %mW/cm^2
detuning=-2258; %3761%4575% %MHz %(-2793);%(-752);
dir=[0.0, 0.0]; % theta & phi
pol=[1, 1i];     % pol_x & pol_y
beam=setBeam(power, detuning, dir, pol);

disp( norm( atom.D*beam.tEj/hbar/2/pi) );

%% Experiment Condition
condition.magB=100.0; % Gauss
condition.Gm2=2*pi* 16.334 * 1e9; % s^(-1), collisional broadening
condition.temperature= 300.0;  % Kelvin
condition.HighPressureApproximation=true;
condition.density = 1.2918e10; % cm^(-3)

%% dynamics
tmin=0; tmax=1e3; dt=10; 
init_state=atom.LS.cPg/atom.sw.gg;
dyn = PumpingDynamics( atom, beam, condition, tmin, tmax, dt, init_state );

%% plot result
subplot(1, 2, 1);
plot(dyn.time/1e3,dyn.state, 'd-');
xlabel('Time (ms)')
ylabel('Sublevel populations')
legend('2,2','2,1','2,0','2,-1','2,-2','1,-1','1,0','1,1')

subplot(1, 2, 2);
plot(dyn.time/1e3,dyn.observables.spin, 'd-');
xlabel('Time (ms)')
ylabel('Spin')
legend('Sx', 'Sy', 'Sz')
