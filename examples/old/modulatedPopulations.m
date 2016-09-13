clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'
LS=LiouvilleSpace(atom);
%% ****************************************
    B=10; %static magnetic field in Gauss;
    Gmp=1000; %Mean pumping rate
    kappa=0; %Shift parameter, Eq(6.85)
    Kj=[0 0 0.25]; %Fictitious spin, [Kx Ky Kz] = . Eq(6.79)?
    Bx=0.02; %Peak oscillating field in Gauss. 
%% *************************************************
I=atom.qn.I; S=atom.qn.S;
a=atom.a; b=atom.b;
    
    EB=EnergyBasis(atom,B);
    mug=EB.mug;   %mug in energy basis
    fgl=EB.fgl; fgr=EB.fgr; %the left and right versions of low-field labels f and m for Liouville space
    mgl=EB.mgl; mgr=EB.mgr;

H=Hamiltonian(atom,B);%Hamiltonian
eigVg=eigH(H.uHg);    Eg=eigVg.E;

HgC=LSHamiltonian(atom,B);%Liouville-space Hamiltonian
Hp1=-Bx*mug(:,:,1)/2;%Fourier amplitude of H Eq(7.58)
Hp1C=Commutator(Hp1);%Liouville version

op=opticalPumpingMatixAop(atom,B,Kj,kappa); %static damping operator, Eq(6.86)
%% ******************************isolated magnetic resonances
Lcp1=fgl==a&mgl==a&fgr==b&mgr==b;%logical var. of |aa><bb|  Eq(7.59)
Lcm1=fgl==b&mgl==b&fgr==a&mgr==a;%logical var. of |bb><aa|

Lp=logical(LS.cPg);%logical variable for populations
L=Lp|Lcp1|Lcm1;%logical variable for secular elements of rho
nk=Lcp1-Lcm1; NL=diag(nk);%indices and effective spin operator

G0s=ModulatedDampingOperator(atom,nk,Gmp,HgC,Hp1C,L,op);%damping operator %no tuning

    om0=(Eg(1)-Eg(atom.sw.gg))/hbar;%resonance freq.
    num=.1e6; nnu=201;%maximum detuning and number of samples
    om=2*pi*linspace(-num,num,nnu);%sample detunings
    rhosin=zeros(sum(L),nnu);%initialize secular density matrix
    for k=1:nnu
        Gs=G0s-1i*(om0+om(k))*NL(L,L);%include tuning
        rhosin(:,k)=null(Gs);%evaluate steady state
        rhosin(:,k)=rhosin(:,k)/(Lp(L)'*rhosin(:,k));
    end
    figure (1);clf
    subplot(2,1,1); plot(om/(2*pi*1e3),real(rhosin(Lp(L),:))'); grid on;
    xlabel('Microwave detuning in kHz'); ylabel('Sublevel populations');
%% **********************************Zeeman magnetic resonances
L=fgl==fgr;%logical var. for Zeeman coherences and populations Eq(7.64)
nk=2*(fgl-I).*mgl-2*(fgr-I).*mgr; NL=diag(nk);%"spin" Eq(7.65)

G0s=ModulatedDampingOperator(atom,nk,Gmp,HgC,Hp1C,L,op);%damping operator %no tuning

    om0=(Eg(1)-Eg(2*a+1))/(2*a*hbar);%resonance frequency
    rhosin=zeros(sum(L),nnu);%initialize secular density matrix
    for k=1:nnu
        Gs=G0s-1i*(om0+om(k))*NL(L,L);%include tuning
        rhosin(:,k)=null(Gs);%evaluate steady state
        rhosin(:,k)=rhosin(:,k)/(Lp(L)'*rhosin(:,k));
    end
    subplot(2,1,2); plot(om/(2*pi*1e3),real(rhosin(Lp(L),:))'); grid on
    xlabel('Radiofrequency detuning in kHz'); ylabel('Sublevel populations');
%% ***********************************Push-Pull pumping
Lcp1=fgl==a&mgl==0&fgr==b&mgr==0;%logical var. of |a0><b0|
Lcm1=fgl==b&mgl==0&fgr==a&mgr==0;%logical var. of |b0><a0|
L=Lp|Lcp1|Lcm1;%logical variable for secular elements of rho
nk=Lcp1-Lcm1; NL=diag(nk);%mult. quant. operator

%***************
alpha=1; %Light-modulation parameter %200;
%*************
m=1:2; fm=real(besselj(m,1i*alpha)./(1i.^m.*besselj(0,1i*alpha)));%sidebands Eq(7.67)
x=linspace(-.5,1.5,400);%time in oscillation periods
y=exp(alpha*cos(2*pi*x))/besselj(0,1i*alpha); %Eq(7.13)
figure (2);clf; subplot(2,1,2); plot (x,y); grid on
xlabel('Time in oscillation periods');ylabel ('Modulatation factor, f')

tAop=SecularOpticalPumpingMatrix_tAop(atom,nk,op,fm,kappa);%secular optical pumping matrix Eq(7.69)
G0s=1i*HgC(L,L)/hbar+Gmp*tAop(L,L);%Gs no tuning Eq(6.86)

    om0=(Eg(a+1)-Eg(3*a+1))/hbar;%resonance frequency
    num=1e3; nnu=101;%maximum detuning and number of samples
    om=2*pi*linspace(-num,num,nnu);%sample detunings
    rhosin=zeros(sum(L),nnu);%initialize secular density matrix
    for k=1:nnu
        Gs=G0s-1i*(om0+om(k))*NL(L,L);%include tuning
        rhosin(:,k)=null(Gs);%evaluate steady state
        rhosin(:,k)=rhosin(:,k)/(Lp(L)'*rhosin(:,k));
    end
    subplot (2,1,1); plot(om/(2*pi*1e3),real(rhosin(Lp(L),:))');grid on;
    xlabel('Microwave Detuning in kHz'); ylabel('Sublevel Populations');