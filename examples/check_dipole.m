clear;clc;

coilx=Condition.Coil('coilx', 0.0);
coily=Condition.Coil('coily', 0.0);
coilz=Condition.Coil('coilz', 1e-10);

rb=Atom.AlkaliMetal('87Rb', {coilx, coily, coilz});


D1j=rb.dipole{1};
D1x=D1j(:,:,1); D1y=D1j(:,:,2); D1z=D1j(:,:,3);
D1p=-(D1x+1i*D1y)/sqrt(2); 
D1m= (D1x-1i*D1y)/sqrt(2); 
D10=  D1z;



D2j=rb.dipole{2};
D2x=D2j(:,:,1); D2y=D2j(:,:,2); D2z=D2j(:,:,3);
D2p=-(D2x+1i*D2y)/sqrt(2); 
D2m= (D2x-1i*D2y)/sqrt(2); 
D20=  D2z;

D2p(abs(D2p)<1e-6)=0;
D2m(abs(D2m)<1e-6)=0;
D20(abs(D20)<1e-6)=0;


dipole_amplitude = rb.parameters.dipole;


rb_old_D1 = atomParameters('Rb87D1');
rb_old_D2 = atomParameters('Rb87D2');
[rb_old_D1.D/(100*10*c_velocity), dipole_amplitude(1)]
[rb_old_D2.D/(100*10*c_velocity), dipole_amplitude(2)]