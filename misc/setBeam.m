function beam=setBeam(power,detuning,thetaD,phiD,Etheta,Ephi)
fundamental_constants
Sl=1e4*power;%convert form mW/cm^2 to erg/(s cm^2)
beam.Dw=2*pi*1e6*detuning;  %MHz 
theta=thetaD*pi/180; phi=phiD*pi/180; %angles in radians
Ej(1)=Etheta*cos(theta)*cos(phi)-Ephi*sin(phi);
Ej(2)=Etheta*cos(theta)*sin(phi)+Ephi*cos(phi);
Ej(3)=-Etheta*sin(theta); %Cartesian projections
beam.EjOr=Ej/norm(Ej); %the orientation of electric field
beam.tEj=sqrt(2*pi*Sl/c)*beam.EjOr;%field in esu/cm^2

beam.s=1i*cross(beam.EjOr,conj(beam.EjOr));
end