clear;clc;

coil=Condition.Coil('coil');

rb=Atom.AlkaliMetal('87Rb');

res=rb.energy_spectrum(Atom.Subspace.GS, coil.sweep_mag(0, 0.5000) );

plot(res.magB, res.energy)
