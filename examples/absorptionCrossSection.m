clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'
LS=LiouvilleSpace(atom);
%****************************************
B=1; %static magnetic field in Gauss;
TK=300; %Kelvin temperature (K) 
Gm2=2*pi/(2*atom.pm.te); %the damping rate of optical coherence
%****  parameters for laser field
power=40; %mW/cm^2
%should choose the appropriate frequency according to the energy distribution
detuning=-2258; %3761%4575% %MHz %(-2793);%(-752); %
%colatitude and azimuthal angles of beam direction in degrees
thetaD = 45;%beam colatitude angle in degrees
phiD = 0;%beam azimuthal angle in degrees
Etheta = 1;%relative field along theta
Ephi= 1i;%relative field along phi
%*********************************************************
beam=setBeam(power,detuning,thetaD,phiD,Etheta,Ephi);%the beam informations

    H=Hamiltonian(atom,B);  %Hamiltonian
    uHg=H.uHg;  uHe=H.uHe;
    eigVg=eigH(uHg);  eigVe=eigH(uHe);
    eigV.Ug=eigVg.U; eigV.Eg=eigVg.E;
    eigV.Ue=eigVe.U; eigV.Ee=eigVe.E;

Dj=dipoleOperator(eigV.Ug,eigV.Ue,atom);
[Hee,Hge,Heg,Hgg]=rfShift(eigV.Ee,eigV.Eg,atom);

tV=interaction(atom,beam,Dj);

sigv=(2*pi/atom.pm.lamJ)*sqrt(kB*TK*NA/atom.pm.MW);%Doppler variance, k*v; v=Eq(6.111)
Dnu1= min(min(Heg/hP))-sigv/2; Dnu2= max(max(Heg/hP))+sigv/2;
ns=2000;%number of sample frequencies
Dnu=linspace(Dnu1,Dnu2,ns); %sample frequencies
sigT=zeros(1,ns); sig0=zeros(1,ns);
for k=1:ns
    %Doppler broadened cross section
    z=-(Heg-hP*Dnu(k)-1i*hbar*Gm2)/(hbar*sigv*sqrt(2)); %Eq(6.117)
    tWT=tV.*w(z)*1i*sqrt(pi/2)/(hbar*sigv); %Eq(8.27); %w(z) is the Faddeeva function 
    dHgT=-tV'*tWT; %Eq(6.12)
    %Eq(8.17) %1e4*power:convert power from mW/cm^2 to erg/(s cm^2)
    sigT(k)=-(2*atom.pm.weg/(1e4*power))*imag(trace(dHgT)/atom.sw.gg); 
   
    %cross section for atoms at rest
    tW0=tV./(Heg-hP*Dnu(k)-1i*hbar*Gm2);
    dHg0=-tV'*tW0;
    sig0(k)=-(2*atom.pm.weg/(1e4*power))*imag(trace(dHg0)/atom.sw.gg);
end
figure (1); clf
subplot(2,1,1); plot(Dnu,sigT); grid on;
ylabel('\sigma in cm^2')
subplot(2,1,2); plot(Dnu,sig0); grid on;
ylabel('\sigma in cm^2')
xlabel('Detuning in GHz')