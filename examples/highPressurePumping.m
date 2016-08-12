clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'

%% Laser Beam
power=40;       %0.00001; %mW/cm^2
detuning=-2258; %3761%4575% %MHz %(-2793);%(-752);
dir=[45.0, 0.0]; % theta & phi
pol=[1, 1i];     % pol_x & pol_y
beam=setBeam(power, detuning, dir, pol);

%% Experiment Condition
condition.magB=1; % Gauss
condition.Gm2=2*pi* 20.0 * 1e9; % s^(-1), collisional broadening
condition.temperature= 300.0;  % Kelvin

%% Analysis

H=Hamiltonian(atom, condition); % Hamiltonian in erg
eigenG=Diagnalize(H.uHg);
eigenE=Diagnalize(H.uHe);
% Dj=ElectricDipole(atom, eigenG, eigenE);
[~,~,Heg,~]=TransitionFrequency(atom, eigenG, eigenE);
tV=AtomPhotonInteraction(atom, beam, condition);
tW=WMatrix(atom, beam, condition, tV, Heg);
effHg=effectiveHg(atom, beam, condition);

% eHg=effectiveHg( atom, magB, beam, Gm2 );%, temperature
% 
% rho0=atom.LS.cPg/atom.sw.gg;
% options=odeset('RelTol',1e-4,'AbsTol',1e-4*ones(1,atom.sw.gg^2));
% [t1,rho1] = ode45( @drho, [0:1e-2:100] ,rho0, options, atom, eHg); %ode45
%  rLp=logical(atom.LS.rPg);
%      [row,~]=size(t1);
%      for k=1:row
%      rho11(k,:)=real(rho1(k,rLp));
%      end
% figure; clf;
% subplot(1,2,1)
% plot(t1,rho11);
% xlabel('Time in units of what')
% ylabel('Sublevel populations')
% 
%  Gmp1=-trace(imag(eHg))*2.0/hbar;
%  kappa1=2*trace(real(eHg))/(hbar*Gmp1);
% 
% Gmp=-imag(eHgApprox)*2/hbar;   %%Mean pumping rate
% kappa=2*real(eHgApprox)/(hbar*Gmp);  %Shift parameter, Eq(6.85)
% %Fictitious spin, [Kx Ky Kz] = . Eq(6.79) %[sqrt(2)/4 0 sqrt(2)/4];
% Kj = beam.s * atom.pumpR;
%  
% 
% %% *********************************************
% op=opticalPumpingMatixAop(atom,magB,Kj,kappa); %high-pressure optical pumping matrix, Eq(6.87)
% HgC=LSHamiltonian(atom,magB);%HgC=flat(eigVg.H)-sharp(eigVg.H);%Liouville-space Hamiltonian
% G=1i*HgC/hbar+Gmp*op.Aop; %static damping operator, Eq(6.86)
% 
%  eHg
%  eHg2=eHgApprox*(eye(atom.sw.gg)-4*(Kj(1)*op.Sj(:,:,1)+Kj(2)*op.Sj(:,:,2)-Kj(3)*op.Sj(:,:,3)))
% 
% %% *********************************************
% Lp=logical(atom.LS.cPg);%logical variable for populations
% nt=100;%number of sample points
% t=linspace(0,40,nt);%sample times in units of 1/Gmp
% rhoc=zeros(atom.sw.gg,nt);%initialize compactified density matrix
% for k=1:nt%evaluate transient
%     rhocR(:,k)=expm(-t(k)*G(Lp,Lp)/Gmp)*atom.LS.cPg(Lp)/atom.sw.gg; %rate equations
%     rho=expm(-t(k)*G/Gmp)*atom.LS.cPg/atom.sw.gg; %master equations
%     rhoc(:,k)=real(rho(Lp));
% end
% subplot(1,2,2)
% plot(t,rhocR); grid on; hold on
%  rhocinR=null(G(Lp,Lp));
%  rhocinR=rhocinR/sum(rhocinR); %steady state (rate equations)
% plot(t,rhocinR*ones(1,nt), '-.')
% plot(t,rhoc);
% rhocin=null(G);
% rhocin(Lp)=real(rhocin(Lp))/sum(real(rhocin(Lp))); %steady state (master equations)
% plot(t,rhocin(Lp)*ones(1,nt), '-.')
% xlabel('Time in units of 1/\Gamma_p^{\{g\}}')
% ylabel('Sublevel populations')
% legend('2,2','2,1','2,0','2,-1','2,-2','1,-1','1,0','1,1')
