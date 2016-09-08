clear;clc;

coil=Condition.Coil('coil');
coil.set_magB(0.2);

rb=Atom.AlkaliMetal('87Rb');
cs=Atom.AlkaliMetal('133Cs');

rb.set_eigen(coil);
cs.set_eigen(coil);

temperature=273.15+25; 
gasRb=VaporCell.Gas(rb, 'vapor', temperature);
gasCs=VaporCell.Gas(cs, 'vapor', temperature);

%gases=VaporCell.MixedGas({gasRb, gasCs});
gases=VaporCell.MixedGas({gasRb});

pumpBeam=Laser.AlkaliLaserBeam(1, rb, 'D1', 0, [0 0 1], [1, 1i], 1e-3);

gases.set_pumping_rate(pumpBeam);

vect=rb.mean_vector();