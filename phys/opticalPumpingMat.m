function Aop=opticalPumpingMat(Asd,Aex,SC,Kj,kappa)
%high-pressure optical pumping matrix
Aop=Asd-Kj(1)*Aex(:,:,1)-Kj(2)*Aex(:,:,2)-Kj(3)*Aex(:,:,3) ...
    -2*1i*kappa*(Kj(1)*SC(:,:,1)+Kj(2)*SC(:,:,2)+Kj(3)*SC(:,:,3));
end