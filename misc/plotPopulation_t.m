function plotPopulation_t(th,te,Ng,Ne)
plot(th/te,real(Ng),'b-'); hold on; 
plot(th/te,real(Ne),'r-.');grid on; 
xlabel('Time, \Gamma^{\{ge\}}_{\rm s}t'); 
ylabel('Populations'); legend('Ng','Ne')
end