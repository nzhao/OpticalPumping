function pumping = highPressurePumping( obj, beam )
%HIGHPRESSUREPUMPING Summary of this function goes here
%   Detailed explanation goes here
    
    tV = VaporCell.AtomPhotonInteraction(obj, beam);
    denomMat = VaporCell.DenominatorMat(obj, beam);
    
    pumping.atom_photon_int = tV;
    pumping.denominatorMat = denomMat;
    
    eHg =  -tV'*(tV.*denomMat);
    [dim, ~]=size(eHg);
    
    pumping.effective_Hg = eHg;
    pumping.effective_Shift = real(eHg);
    pumping.effective_Gamma = -imag(eHg);
    pumping.optical_shift = trace(pumping.effective_Shift)/dim;
    pumping.gamma_p = trace(pumping.effective_Gamma)/dim;
    pumping.photon_spin = beam.fictionSpin;
    pumping.absorption_cross_section0 = pumping.gamma_p*2*pi*1e6 / beam.photonFlux; % m^2
end

