function atom=atomParameters(iso)
    fundamental_constants
    switch iso
        case 'Rb87D1'
            atom.qn.I=1.5; atom.qn.S=0.5; atom.qn.J=0.5;
            
            atom.pm.MW=86.9;%grams/mole
            atom.pm.muI=2.751*muN;%nuclear moment in erg/G
            atom.pm.Ag=hP*3417.35e6;%S1/2 dipole coupling coefficient in erg

            atom.pm.lamJ=7947e-8;%D1 wavelength in cm
            atom.pm.Ae=hP*409e6;%P1/2 dipole coupling coefficient in erg
            atom.pm.te=28.5e-9;%spontaneous P1/2 lifetime in s
            atom.pm.Be=0;%none quadrupole coupling

        case 'Rb87D2'
            atom.qn.I=1.5; atom.qn.S=0.5; atom.qn.J=1.5;
            
            atom.pm.MW=86.9;%grams/mole
            atom.pm.muI=2.751*muN;%nuclear moment in erg/G
            atom.pm.Ag=hP*3417.35e6;%S1/2 dipole coupling coefficient in erg

            atom.pm.lamJ=7800e-8;%D2 wavelength in cm 
            atom.pm.Ae=hP*84.852e6;%P3/2 dipole coefficient in erg
            atom.pm.Be=hP*12.611e6;%P3/2 quadrupole coupling coefficient in erg
            atom.pm.te=25.5e-9;%spontaneous P1/2 lifetime in s

        otherwise 
            fprintf('unkonwn atom name "%s"\n', iso);
    end
    
    atom.a=atom.qn.I+.5; atom.b=atom.qn.I-.5;  %ground-state ang. mom. quant. numbs.
    atom.sw=statistical_weights(atom.qn.I,atom.qn.S,atom.qn.J); %(atom);%
    atom.pm.keg=2*pi/atom.pm.lamJ; atom.pm.weg=c*atom.pm.keg;%nominal spatial and temporal frequencies
    atom.pm.feg=c*atom.sw.gJ/(4*atom.pm.weg^2*re*atom.pm.te);%oscillator strength
    atom.mat=spin_matrices(atom);
    atom.LgS=2.00231;% Lande g-value of S1/2 state
    atom.LgJ=atom.sw.gJ/3;%approximate Lande g-value of PJ state
    atom.D=sqrt(atom.sw.gS*hbar*re*c^2*atom.pm.feg/(2*atom.pm.weg));% dipole moment in esu cm
    atom.pm.keg=2*pi/atom.pm.lamJ; %nominal spatial frequencies
    atom.pm.weg=c*atom.pm.keg;%nominal temporal frequencies
   
end