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
    pumping.optical_shift = real(trace(eHg)/dim);
    pumping.gamma_p = - imag(trace(eHg)/dim);
    pumping.photon_spin = beam.fictionSpin;
end

