clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'

%% Laser Beam
power=40;       %0.00001; %mW/cm^2
detuning=-2258; %3761%4575% %MHz %(-2793);%(-752);
dir=[0.0, 0.0]; % theta & phi
pol=[1, 1i];     % pol_x & pol_y
beam=setBeam(power, detuning, dir, pol);

%% Experiment Condition
condition.magB=0.001; % Gauss
condition.Gm2=2*pi* 20.0 * 1e9; % s^(-1), collisional broadening
condition.temperature= 300.0;  % Kelvin
condition.HighPressureApproximation=false;

%% Analysis
eigen   = EigenSystem(atom, condition);
pump    = OpticalPumping(atom, beam, condition, eigen);

rate.shift = 0;
rate.damping = 0.001;
rate.exchange = 0.001;
rhoMat=eye(8)/8;
% exchange= SpinExchange( atom, eigen, rhoMat, eigen.S.Sj, rate);
% G = eigen.G + pump.G + exchange.G;

%% *********************************************

Lp=logical(atom.LS.cPg);%logical variable for populations
nt=1000; t=linspace(0,40,nt);%sample times in units of 1/Gmp
rhoc=zeros(atom.sw.gg,nt);%initialize compactified density matrix
for k=1:nt%evaluate transient
    exchange= SpinExchange( atom, eigen, rhoMat, eigen.S.Sj, rate);
    G = eigen.G + pump.G + exchange.G;
    rhocR(:,k)=expm(-t(k)*G(Lp,Lp)/pump.Gmp)*atom.LS.cPg(Lp)/atom.sw.gg; %rate equations
    rho=expm(-t(k)*G/pump.Gmp)*atom.LS.cPg/atom.sw.gg; %master equations
    rhoc(:,k)=real(rho(Lp));
    rhoMat=reshape(rho, [8 8]);
end

plot(t,rhocR); grid on; hold on
rhocinR=null(G(Lp,Lp));
rhocinR=rhocinR/sum(rhocinR); %steady state (rate equations)
plot(t,rhocinR*ones(1,nt), '-.')
plot(t,rhoc);
rhocin=null(G);
rhocin(Lp)=real(rhocin(Lp))/sum(real(rhocin(Lp))); %steady state (master equations)
plot(t,rhocin(Lp)*ones(1,nt), '-.')
xlabel('Time in units of 1/\Gamma_p^{\{g\}}')
ylabel('Sublevel populations')
legend('2,2','2,1','2,0','2,-1','2,-2','1,-1','1,0','1,1')
