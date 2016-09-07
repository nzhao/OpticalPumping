clear;clc;

coil=Condition.Coil('coil');
coil.set_magB(0.2);

rb=Atom.AlkaliMetal('87Rb');
cs=Atom.AlkaliMetal('133Cs');

rb.set_eigen(coil);
cs.set_eigen(coil);

temperature=300; 
gasRb=VaporCell.Gas(rb, 'vapor', temperature);
gasCs=VaporCell.Gas(cs, 'vapor', temperature);

gases=VaporCell.MixedGas({gasRb, gasCs});

vect=rb.mean_vector();