function tAop=SecularOpticalPumpingMatrix_tAop(atom,nk,op,fm,kappa)
SAmat=SecularApproMat(nk,atom.sw.gg); %secular approx. matrices %Eq.(7.44)
Mp2=SAmat.Mp2; Mp1=SAmat.Mp1;  M0=SAmat.M0;  Mm1=SAmat.Mm1;  Mm2=SAmat.Mm2;

tAop=op.Asd.*(M0+fm(2)*(Mp2+Mm2))-(op.Aex(:,:,3)-2*1i*kappa*op.SC(:,:,3))/2 ...
    .*(fm(1)*(Mp1+Mm1));%secular optical pumping matrix Eq(7.69)
end