clear,clc;
fundamental_constants
atom=atomParameters('Rb87D1'); %input 'Rb87D1' or 'Rb87D2'
LS=LiouvilleSpace(atom);
%***************************************
B=10; %static magnetic field in Gauss;
Gmp=1000; %Mean pumping rate
kappa=0; %Shift parameter, Eq(6.85)
Kj=[0 0 0.25]; %Fictitious spin, [Kx Ky Kz] = . Eq(6.79)?
Bx=0.02; %Peak oscillating field in Gauss. 
%*********************************************
H=Hamiltonian(atom,B);%Hamiltonian
eigVg=eigH(H.uHg);  Ug=eigVg.U;  Eg=eigVg.E;
Aop=opticalPumpingMatixAop(atom,B,Kj,kappa); %static damping operator, Eq(6.86)

    for j=1:3;
    mug(:,:,j)=Ug'*H.umug(:,:,j)*Ug;
    Ijg(:,:,j)=Ug'*atom.mat.aIjg(:,:,j)*Ug;
    Sj(:,:,j)=Ug'*atom.mat.gSj(:,:,j)*Ug;
    end
    I=atom.qn.I; S=atom.qn.S;
    fg=round(-1+sqrt(1+4*(2*diag(Ug'*H.uIS*Ug)+I*(I+1)+S*(S+1))))/2;
    mg=round(2*diag(Ijg(:,:,3)+Sj(:,:,3)))/2;
    x=kron(fg,ones(1,atom.sw.gg)); fgl=x(:); %left f label
    x=x'; fgr=x(:);%right f label
    x=kron(mg,ones(1,atom.sw.gg)); mgl=x(:); %left m label
    x=x'; mgr=x(:);%right m label

HgC=LSHamiltonian(atom,B);%Liouville-space Hamiltonian
Hp1=-Bx*mug(:,:,1)/2;%Fourier amplitude of H
Hp1C=flat(Hp1)-sharp(Hp1);%Liouville version

a=atom.a; b=atom.b;
Lcp1=fgl==a&mgl==a&fgr==b&mgr==b;%logical var. of |aa><bb|
Lcm1=fgl==b&mgl==b&fgr==a&mgr==a;%logical var. of |bb><aa|

Lp=logical(LS.cPg);%logical variable for populations
L=Lp|Lcp1|Lcm1;%logical variable for secular elements of rho
nk=Lcp1-Lcm1; NL=diag(nk);%indices and effective spin operator

gg=atom.sw.gg;
Mp1=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==1;%secular approx. matrices
M0=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==0;
Mm1=nk*ones(1,gg*gg)-ones(gg*gg,1)*nk'==-1;
tHmrC=Hp1C.*(Mp1+Mm1);%secular part of mag. res. interaction
tAop=Aop.*M0;%secular part of optical pumping matrix

G0s=1i*(HgC(L,L)+tHmrC(L,L))/hbar+Gmp*tAop(L,L);%no tuning

om0=(Eg(1)-Eg(gg))/hbar;%resonance freq.
num=.1e6; nnu=201;%maximum detuning and number of samples
om=2*pi*linspace(-num,num,nnu);%sample detunings
rhosin=zeros(sum(L),nnu);%initialize secular density matrix
for k=1:nnu
    Gs=G0s-1i*(om0+om(k))*NL(L,L);%include tuning
    rhosin(:,k)=null(Gs);%evaluate steady state
    rhosin(:,k)=rhosin(:,k)/(Lp(L)'*rhosin(:,k));
end
figure (2);clf
subplot(2,1,1); plot(om/(2*pi*1e3),real(rhosin(Lp(L),:))'); grid on;
xlabel('Microwave detuning in kHz'); ylabel('Sublevel populations');