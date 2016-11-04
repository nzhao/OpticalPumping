function G0s=ModulatedDampingOperator(atom,nk,Gmp,HgC,Hp1C,L,op)
fundamental_constants
  
SAmat=SecularApproMat(nk,atom.sw.gg); %secular approx. matrices %Eq.(7.44)
Mp1=SAmat.Mp1;  M0=SAmat.M0;  Mm1=SAmat.Mm1;

tHmrC=Hp1C.*(Mp1+Mm1);%secular part of mag. res. interaction
tAop=op.Aop.*M0;%secular part of optical pumping matrix

G0s=1i*(HgC(L,L)+tHmrC(L,L))/hbar+Gmp*tAop(L,L); %damping operator %no tuning 
end