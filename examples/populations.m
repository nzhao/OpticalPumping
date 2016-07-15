clear,clc;
fundamental_constants
atom=atomParameters('Rb87D2'); %input 'Rb87D1' or 'Rb87D2'
%****  parameters for laser field
power=40; %mW/cm^2
%should choose the appropriate frequency according to the energy distribution
detuning=-2256; %MHz %(-2793);%(-752);
%colatitude and azimuthal angles of beam direction in degrees
thetaD = 45;%beam colatitude angle in degrees
phiD = 0;%beam azimuthal angle in degrees
Etheta = 1;%relative field along theta
Ephi= 1i;%relative field along phi
%*********
beam=setBeam(power,detuning,thetaD,phiD,Etheta,Ephi);%the beam informations

%*********************************************************
B=1; %static magnetic field in Gauss;
Gmc=.1/atom.pm.te; %Collision rate; 
rt=10; %relative pulse length, rt=tm/te = ;
%*************************************************
G=evolutionOperator(atom,B,Gmc,beam);
LS=LiouvilleSpace(atom);

 tm=rt*atom.pm.te; 
 nt=101;%number of time samples 
 th=linspace(0,tm,nt);%time samples 
 
 te=atom.pm.te;
 [Ne,Ng]=population_t(nt,G,th,atom.sw,LS);
     clf; %plot population(t)
     plot(th/te,real(Ng),'b-'); hold on; 
     plot(th/te,real(Ne),'r-.');grid on; 
     xlabel('Time, \Gamma^{\{ge\}}_{\rm s}t'); 
     ylabel('Populations'); legend('Ng','Ne')

[Nginf,Neinf]=steadyPopulation(G,LS);
     %plot steaady population
     plot(th/te,real(Nginf)*ones(1,nt),'b-');hold on;
     plot(th/te,real(Neinf)*ones(1,nt),'r-.');grid on; 
     xlabel('Time, \Gamma^{\{ge\}}_{\rm s}t'); 
     ylabel('Populations'); legend('Ng','Ne')

nw=51;dw=linspace(beam.Dw-10/atom.pm.te,beam.Dw+10/atom.pm.te,nw); rhow= zeros(LS.gt,nw);
for k=1:nw
    beam.Dw=dw(k);
    G=evolutionOperator(atom,B,Gmc,beam);
    rhow(:,k)=null(G);rhow(:,k)=rhow(:,k)/(LS.rP*rhow(:,k));
end
    %plot sublevel populations
    figure(2);
    subplot(2,1,1)
    plot(dw/(2*pi*1e6),real(LS.rNg*rhow),'b-');hold on;%statepopulations
    plot(dw/(2*pi*1e6),real(LS.rNe*rhow),'r-.');grid on;
    ylabel('StatePopulations');
    legend('Ng','Ne')
    subplot(2,1,2);%sublevel populations
    plot(dw/(2*pi*1e6),real(rhow(LS.LrNg,:)),'b-');hold on;
    plot(dw/(2*pi*1e6),real(rhow(LS.LrNe,:)),'r-.');grid on;
    xlabel('Detuning,\Delta\nu inMHz');
    ylabel('SublevelPopulations');