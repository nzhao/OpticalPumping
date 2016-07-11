%% Atomic Level Structure
% This example, using Rb87, shows the energy level structures of alkali metal atoms in magnetic fields.
% Using the following commands to get parameters of Rb87 - D1 transition

clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'

%%
% Using _Hamiltonian_ command, one can get the spin Hamiltonian for a given
% magnetic field strength. In the following we compute the full spectrum of
% Rb87 from zero field to strong field (e.g. 1 Telsa).

Bmax=10000; %max B in Gauss
nB=501; dB=linspace(0,Bmax,nB);
Eg=zeros(nB, atom.sw.gg); Ee=zeros(nB, atom.sw.ge);
for k=1:nB 
    H=Hamiltonian(atom,dB(k));%Hamiltonian [uHg,uHe]
    eigVg=eigH(H.uHg);
    eigVe=eigH(H.uHe);

    Eg(k,:)=eigVg.E * erg2GHz; %y axis for ground states %GHz
    Ee(k,:)=eigVe.E * erg2GHz; %y axis for excited states %GHz
end

%% Example: Rb87 D1 line - weak field (anomalous Zeeman effect)
% The hyperfine splitting of Rb87 is 6.8 GHz (for ground state) and 814 MHz
% (for excited state) respectively. When the Zeeman energy is much smaller
% than the hyperfine splitting, the interaction is described by 
% 
% $$ H=g_F \mu_B B F_z, $$
%
% where _gF_= -0.7 MHz/G and +0.7 MHz/G, respectively for F=1 and 2
% (ground state), and -0.23 MHz/G and +0.23 MHz/G for excited state.
% Notice that, the sign of _gF_ are opposite for _F_=1 and _F_=2.
%
% Here displays the splittings at 20 Gauss.
disp( 1e3*[(Eg(2,:)-Eg(1,:))/dB(2); (Ee(2,:)-Ee(1,:))/dB(2)]' )

%%
% Plot of energy levels for _B_=0 to 200 Gauss.

figure; clf;
subplot(1,2,1)
plot(dB(1:11), Eg(1:11, :));
ylabel('Ground state energies (GHz)');
xlabel('Magnetic field (G)');

subplot(1,2,2)
plot(dB(1:11), Ee(1:11, :));
ylabel('Excited state energies (GHz)');
xlabel('Magnetic field (G)');


%% Example: Rb87 D1 line - strong field (Paschen-Back effect)
% When the Zeeman energy is much larger than the hyperfine splitting, the
% atom can be described by 
% 
% $$ H=\mu_B B_z(g_J J_z + g_I I_z), $$
%
% where g_J is calculated as
%
% $$ g_J = 1 + \frac{J(J+1)+S(S+1)-L(L+1)}{J(J+1)}$$
%
% Full plot of energy levels up to _B_= 10000 Gauss.
figure; clf;
subplot(1,2,1)
plot(dB, Eg);
ylabel('Ground state energies (GHz)');
xlabel('Magnetic field (G)');

subplot(1,2,2)
plot(dB, Ee);
ylabel('Excited state energies (GHz)');
xlabel('Magnetic field (G)');
