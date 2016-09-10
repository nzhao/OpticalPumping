clear;clc;

coil=Condition.Coil('coil');
coil.set_magB(0.2);

rb=Atom.AlkaliMetal('87Rb', coil);
cs=Atom.AlkaliMetal('133Cs', coil);

temperature=273.15+25; 
gasRb=VaporCell.Gas(rb, 'vapor', temperature);
gasCs=VaporCell.Gas(cs, 'vapor', temperature);

gases=VaporCell.MixedGas({gasRb, gasCs});

pumpBeam=Laser.AlkaliLaserBeam(1, rb, Atom.Transition.D1, 0, ...
                               [0 0 1], [1, 1i], 1e-3);

gases.set_pumping_rate(pumpBeam);

vect=rb.mean_vector();