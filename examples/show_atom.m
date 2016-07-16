atom=atomParameters('Rb87D2');
power=40;
detuning=-2256;
thetaD = 0;
phiD = 0;
Etheta = 1;
Ephi= 1i;
beam=setBeam(power,detuning,thetaD,phiD,Etheta,Ephi);
magB=10;
Gmc=.1/atom.pm.te;
G=evolutionOperator(atom,magB,Gmc,beam);
LS=LiouvilleSpace(atom);

rho=null(G);
rho=rho/(LS.rP*rho);
dim=atom.sw.gg+atom.sw.ge;
rho=reshape( rho, [dim, dim]);
%rho=diag(rand(1, atom.sw.gg+atom.sw.ge)); rho=rho/trace(rho);

[fig, res] = plotPumping(atom, beam, magB, rho);