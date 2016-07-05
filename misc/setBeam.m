function [Dw,tEj]=setBeam()
fundamental_constants
Sl=1e4*40;%convert form mW/cm^2 to erg/(s cm^2)
%should choose the appropriate frequency according to the energy distribution
Dw=2*pi*1e6*(-2256); %(-2793);%(-752); %MHz 
%colatitude and azimuthal angles of beam direction in degrees
thetaD = 45;%beam colatitude angle in degrees
phiD = 0;%beam azimuthal angle in degrees
theta=thetaD*pi/180; phi=phiD*pi/180; %angles in radians
Etheta = 1;%relative field along theta
Ephi= 1i;%relative field along phi
Ej(1)=Etheta*cos(theta)*cos(phi)-Ephi*sin(phi);
Ej(2)=Etheta*cos(theta)*sin(phi)+Ephi*cos(phi);
Ej(3)=-Etheta*sin(theta);%Cartesian projections
tEj=sqrt(2*pi*Sl/c)*Ej/norm(Ej);%field in esu/cm^2
end