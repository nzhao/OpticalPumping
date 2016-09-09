clear;clc;

coil=Condition.Coil('coil');

rb=Atom.AlkaliMetal('87Rb');

res=rb.energy_spectrum(1, 0, 0.5000, 101);

plot(res.magB, res.energy)
