function denominator_mat = DenominatorMat( gas, beam )
%DENOMINATORMAT Summary of this function goes here
%   Detailed explanation goes here

    dimG = gas.atom.dim(1);
    dimE = gas.atom.dim(1+beam.refTransition);


%    temperature=gas.temperature;

    detune = beam.detune;
    gamma =  gas.gamma2;
%    energy_mat = Heg - detune - 1i*gamma; % MHz
    
    denominator_mat = -ones(dimE,dimG)/(detune+1i*gamma);
%     if condition.HighPressureApproximation
%         denominator_mat = -ones(size(tV))/(detune+1i*gamma);
%     elseif temperature == 0 
%         denominator_mat = ones(size(tV))./energy_mat;
%     else
%         wavenumber_k = 2*pi/atom.pm.lamJ; % cm^(-1), wave number k
%         thermal_v = sqrt(kB*temperature*NA/atom.pm.MW); % cm/s, v=Eq(6.111)
%         sigv = wavenumber_k*thermal_v; % in s^(-1),Doppler variance, k*v; 
%         sigv1= sqrt(2)*hbar*sigv * erg2MHz;
%         denominator_mat= 1i*sqrt(pi)/sigv1 * w( -energy_mat/sigv1 ); % w(z) is the Faddeeva function
%     end

end

