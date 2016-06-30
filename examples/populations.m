clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'
[Dw,tEj]=setBeam();%the beam informations


%*********************************************************
%atom.qn.I=0.5;  %%%%%%%%%%%%%%%%%%%%%%%%%%
B=1; %static magnetic field in Gauss;
Gmc=.1/atom.pm.te; %Collision rate; 
rt=10; %relative pulse length, rt=tm/te = ;
%*************************************************
G=evolutionOperator(atom,B,Gmc,Dw,tEj);
LS=LiouvilleSpace(atom.sw.gg,atom.sw.ge);

 tm=rt*atom.pm.te; 
 nt=101;%number of time samples 
 th=linspace(0,tm,nt);%time samples 
 
 [Ne,Ng]=population_t(nt,G,th,atom.sw,LS);
 clf; 
 plotPopulation_t(th,atom.pm.te,Ng,Ne);
 [Nginf,Neinf]=steadyPopulation(G,LS);
 plotSteadyPopulation(atom.pm.te,th,nt,Nginf,Neinf);

nw=21;dw=linspace(Dw-3/atom.pm.te,Dw+3/atom.pm.te,nw); rhow= zeros(LS.gt,nw);
for k=1:nw
    G=evolutionOperator(atom,B,Gmc,dw(k),tEj);
    rhow(:,k)=null(G);rhow(:,k)=rhow(:,k)/(LS.rP*rhow(:,k));
end
plotSublevelPopulations(dw,rhow,LS);