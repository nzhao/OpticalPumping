function [Ne,Ng]=population_t(nt,G,th,sw,LS)
rhot=zeros(LS.gt,nt);%initialize density matrix 
 rho0=[zeros(sw.ge^2+2*sw.ge*sw.gg,1);LS.cPg]/sw.gg;%density matrix at t=0 
for k=1:nt 
rhot(:,k)=expm(-G*th(k))*rho0; 
end 
Ne=LS.rNe*rhot;%excited-state probability 
Ng=LS.rNg*rhot;%ground-state probability 
end