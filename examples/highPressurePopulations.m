clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'
LS=LiouvilleSpace(atom);
%% ****  parameters for laser field
power=40; %mW/cm^2
%should choose the appropriate frequency according to the energy distribution
detuning=-2258;%3761%4575% %MHz %(-2793);%(-752);
%colatitude and azimuthal angles of beam direction in degrees
thetaD = 45;%beam colatitude angle in degrees
phiD = 0;%beam azimuthal angle in degrees
Etheta = 1;%relative field along theta
Ephi= 1i;%relative field along phi
%************************************************
beam=setBeam(power,detuning,thetaD,phiD,Etheta,Ephi);%the beam informations
Gm2=2*pi/(2*atom.pm.te);%the damping rate of optical coherence
eHg=effectiveHgHighPressure(atom,power,detuning,Gm2); %Eq(6.78)
Gmp=-imag(eHg)*2/hbar;   %%Mean pumping rate
kappa=2*real(eHg)/(hbar*Gmp);  %Shift parameter, Eq(6.85)
%Fictitious spin, [Kx Ky Kz] = . Eq(6.79) %[sqrt(2)/4 0 sqrt(2)/4];
Kj=1i*cross(beam.EjOr,conj(beam.EjOr))*(-1)^(atom.qn.J-atom.qn.S)/atom.sw.gJ;
 
B=1; %static magnetic field in Gauss;
%% *********************************************
op=opticalPumpingMatixAop(atom,B,Kj,kappa); %high-pressure optical pumping matrix, Eq(6.87)
HgC=LSHamiltonian(atom,B);%HgC=flat(eigVg.H)-sharp(eigVg.H);%Liouville-space Hamiltonian
G=1i*HgC/hbar+Gmp*op.Aop; %static damping operator, Eq(6.86)
%% *********************************************
Lp=logical(LS.cPg);%logical variable for populations
nt=100;%number of sample points
t=linspace(0,40,nt);%sample times in units of 1/Gmp
rhoc=zeros(atom.sw.gg,nt);%initialize compactified density matrix
for k=1:nt%evaluate transient
    rhocR(:,k)=expm(-t(k)*G(Lp,Lp)/Gmp)*LS.cPg(Lp)/atom.sw.gg; %rate equations
    rho=expm(-t(k)*G/Gmp)*LS.cPg/atom.sw.gg; %master equations
    rhoc(:,k)=real(rho(Lp));
end
clf;plot(t,rhocR); grid on; hold on
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
