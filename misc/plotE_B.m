function E_B=plotE_B(EgB,EeB,Bmax)
%plot the ground and excited levels' hyperfine structure in an external magnetic field

figure(2); clf;
subplot(1,2,1)
plot(EgB(:,1),EgB(:,2:end));xlim([0 Bmax]);
ylabel('Ground state energies (GHz)');
xlabel('Magnetic field (G)');
 subplot(1,2,2)
plot(EeB(:,1),EeB(:,2:end));xlim([0 Bmax]);
ylabel('Excited state energies (GHz)');
xlabel('Magnetic field (G)');

end