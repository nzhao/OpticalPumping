clear;clc;

coilx=Condition.Coil('coilx');
coily=Condition.Coil('coily');
coilz=Condition.Coil('coilz');

rb=Atom.AlkaliMetal('87Rb', {coilx, coily, coilz});


res=rb.energy_spectrum(Atom.Subspace.GS, {coilx, coily,coilz.sweep_mag(0, 0.5000)} );

plot(res.magB, res.energy)
