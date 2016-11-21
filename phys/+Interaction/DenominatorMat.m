function denominator_mat = DenominatorMat( gas, beam, opt )
%DENOMINATORMAT Summary of this function goes here
%   Detailed explanation goes here
    if isa(opt, 'double')
        v = opt;
        approx = 'None';
    elseif isa(opt, 'char')
        approx = opt;
    else
        error('wrong option type: %s', class(opt));
    end
    
    dimG = gas.atom.dim(1);
    dimE = gas.atom.dim(1+beam.refTransition);
    
    atom_to_ref_detune = ( gas.atom.parameters.omega(beam.refTransition)...
                         - beam.refAtom.parameters.omega(beam.refTransition) ) /2/pi*1e-6;
    detune = beam.detune - atom_to_ref_detune;
    gamma =  gas.gamma2 + 0.5*gas.atom.parameters.gamma_s(beam.refTransition);
    Heg = gas.atom.eigen.transFreq{1+beam.refTransition, 1};

    switch approx
        case 'None'
            doppler_shif = beam.wavenumber*v /2/pi *1e-6;
            energy_mat = Heg - (detune - doppler_shif) - 1i*gamma; % MHz
            denominator_mat = ones(dimE,dimG)./energy_mat;
        case 'DopplerAverage'
            doppler_sigma_v = gas.dopplerBroadening();
            sigma = sqrt(2)*beam.wavenumber*doppler_sigma_v /2/pi *1e-6;
            energy_mat = Heg + detune - 1i*gamma; % MHz
            denominator_mat= 1i*sqrt(pi)/sigma * w_Fadeeva( -energy_mat/sigma ); % w(z) is the Faddeeva function
        case 'HighPressure'
            denominator_mat = -ones(dimE,dimG)/(detune+1i*gamma);
        otherwise
            error('non-supported approximation: %s', approx);
    end

end

