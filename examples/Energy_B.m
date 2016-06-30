clear,clc;
fundamental_constants
rb87=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'

Bmax=10001; 
nB=1001;dB=linspace(0,Bmax,nB);
for k=1:nB 
    [uHg,uHe]=Hamiltonian(rb87,dB(k));%Hamiltonian
    eigVg=eigH(uHg);
    eigVe=eigH(uHe);

    Eg2(k,:)=1e-9*eigVg.E'/hP; %y axis for ground states %GHz
    Ee2(k,:)=1e-9*eigVe.E'/hP; %y axis for excited states %GHz
end
EgB=[dB' Eg2];
EeB=[dB' Ee2];

%% plot result
figure(2); clf;
subplot(1,2,1)
plot(EgB(:,1),EgB(:,2:end));xlim([0 Bmax]);
ylabel('Ground state energies (GHz)');
xlabel('Magnetic field (G)');
subplot(1,2,2)
plot(EeB(:,1),EeB(:,2:end));xlim([0 Bmax]);
ylabel('Excited state energies (GHz)');
xlabel('Magnetic field (G)');