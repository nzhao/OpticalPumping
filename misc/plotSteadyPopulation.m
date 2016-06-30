function plotSteadyPopulation(te,th,nt,Nginf,Neinf)
plot(th/te,real(Nginf)*ones(1,nt),'b-');hold on;
plot(th/te,real(Neinf)*ones(1,nt),'r-.');grid on; 
xlabel('Time, \Gamma^{\{ge\}}_{\rm s}t'); 
ylabel('Populations'); legend('Ng','Ne')
end