function plotSublevelPopulations(dw,rhow,LS)
figure(2); %clf;
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