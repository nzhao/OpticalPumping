function denominator_mat = DenominatorMat( gas, beam, approx )
%DENOMINATORMAT Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 3
        approx = 'none';
    end

    dimG = gas.atom.dim(1);
    dimE = gas.atom.dim(1+beam.refTransition);

    detune = beam.detune;
    gamma =  gas.gamma2 + 0.5*gas.atom.parameters.gamma_s(beam.refTransition);
    doppler_sigma_v = gas.dopplerBroadening();
    sigma = sqrt(2)*beam.wavenumber*doppler_sigma_v /2/pi *1e-6;

    Heg = gas.atom.eigen.transFreq{1, 1+beam.refTransition};
    energy_mat = Heg + detune - 1i*gamma; % MHz
    
    if strcmp(approx, 'HighPressure')
        denominator_mat = -ones(dimE,dimG)/(detune+1i*gamma);
% 	elseif strcmp(approx, 'ZeroTemperature')
%         denominator_mat = ones(size(tV))./energy_mat;
    else
        denominator_mat= 1i*sqrt(pi)/sigma * w_Fadeeva( -energy_mat/sigma ); % w(z) is the Faddeeva function
    end

end

