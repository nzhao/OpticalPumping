clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'
LS=LiouvilleSpace(atom);
%***************************************
B=1; %static magnetic field in Gauss;
Gmp=1000; %Mean pumping rate
kappa=0; %Shift parameter, Eq(6.85)
Kj=[0 0 0.25]; %Fictitious spin, [Kx Ky Kz] = . Eq(6.79)?
%*********************************************
G=dampingOperatorG(atom,B,Kj,kappa,Gmp); %static damping operator, Eq(6.86)
Lp=logical(LS.cPg);%logical variable for populations
nt=100;%number of sample points
t=linspace(0,40,nt);%sample times in units of 1/Gmp
rhoc=zeros(atom.sw.gg,nt);%initialize compactified density matrix
for k=1:nt%evaluate transient
    rhoc(:,k)=expm(-t(k)*G(Lp,Lp)/Gmp)*LS.cPg(Lp)/atom.sw.gg;
end
clf; plot(t,rhoc); grid on; hold on
rhocin=null(G(Lp,Lp));rhocin=rhocin/sum(rhocin);%steady state
plot(t,rhocin*ones(1,nt), '-.')
xlabel('Time in units of 1/\Gamma_p^{\{g\}}')
ylabel('Sublevel populations')
