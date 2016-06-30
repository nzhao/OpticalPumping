function [atom,D]=atomParameters(iso)
fundamental_constants
if iso=='Rb87D1' %D1pumping
   
         atom.qn.I=1.5; atom.qn.S=0.5; atom.qn.J=0.5;
 sw=statistical_weights(atom.qn.I,atom.qn.S,atom.qn.J); %(atom);%
 atom.pm.MW=86.9;%grams/mole
 atom.pm.muI=2.751*muN;%nuclear moment in erg/G
 atom.pm.Ag=hP*3417.35e6;%S1/2 dipole coupling coefficient in erg

    atom.pm.lamJ=7947e-8;%D1 wavelength in cm
    atom.pm.Ae=hP*409e6;%P1/2 dipole coupling coefficient in erg
    atom.pm.te=28.5e-9;%spontaneous P1/2 lifetime in s
    atom.pm.Be=0;%none quadrupole coupling
 atom.pm.keg=2*pi/atom.pm.lamJ; atom.pm.weg=c*atom.pm.keg;%nominal spatial and temporal frequencies
 atom.pm.feg=c*sw.gJ/(4*atom.pm.weg^2*re*atom.pm.te);%oscillator strength
 D=sqrt(sw.gS*hbar*re*c^2*atom.pm.feg/(2*atom.pm.weg));% dipole moment in esu cm
else if iso=='Rb87D2' %D2pumping
        atom.qn.I=1.5; atom.qn.S=0.5; atom.qn.J=1.5;
 sw=statistical_weights(atom.qn.I,atom.qn.S,atom.qn.J);
 atom.pm.MW=86.9;%grams/mole
 atom.pm.muI=2.751*muN;%nuclear moment in erg/G
 atom.pm.Ag=hP*3417.35e6;%S1/2 dipole coupling coefficient in erg

    atom.pm.lamJ=7800e-8;%D2 wavelength in cm
    atom.pm.Ae=hP*84.852e6;%P3/2 dipole coefficient in erg
    atom.pm.Be=hP*12.611e6;%P3/2 quadrupole coupling coefficient in erg
    atom.pm.te=25.5e-9;%spontaneous P1/2 lifetime in s
 atom.pm.keg=2*pi/atom.pm.lamJ; atom.pm.weg=c*atom.pm.keg;%nominal spatial and temporal frequencies
 atom.pm.feg=c*sw.gJ/(4*atom.pm.weg^2*re*atom.pm.te);%oscillator strength
 D=sqrt(sw.gS*hbar*re*c^2*atom.pm.feg/(2*atom.pm.weg));% dipole moment in esu cm
end    
end