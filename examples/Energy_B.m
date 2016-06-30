clear,clc;
fundamental_constants
[atom,D]=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'

Bmax=10001; %magnetic field's maximum
nB=1001;dB=linspace(0,Bmax,nB);
for k=1:nB 
    %dB(k) Static magnetic field in Gauss 
[uHg,uHe]=Hamiltonian(atom,dB(k));%Hamiltonian
eigV=eigH(uHg,uHe);
%B(k)=dB(k); %x axis
Eg2(k,:)=1e-9*eigV.Eg'/hP; %y axis for ground states %GHz
Ee2(k,:)=1e-9*eigV.Ee'/hP; %y axis for excited states %GHz
end
EgB=[dB' Eg2];
EeB=[dB' Ee2];
% save EgB.dat EgB -ascii -double -tabs; %save the date
% save EeB.dat EeB -ascii -double -tabs;
plotE_B(EgB,EeB,Bmax);