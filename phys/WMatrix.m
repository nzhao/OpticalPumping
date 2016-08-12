function tW = WMatrix( atom, beam, condition, tV, Heg )
%WMATRIX Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants;

    Gm2=condition.Gm2;
    temperature=condition.temperature;

    detune = hbar*beam.Dw * erg2MHz;
    gamma = hbar*Gm2 * erg2MHz;
    energy_mat = Heg - detune - 1i*gamma; % MHz
    if temperature == 0 
        denominator_mat = ones(size(tV))./energy_mat;
    else
        wavenumber_k = 2*pi/atom.pm.lamJ; % cm^(-1)
        thermal_v = sqrt(kB*temperature*NA/atom.pm.MW);
        sigv = wavenumber_k*thermal_v; % in s^(-1),Doppler variance, k*v; v=Eq(6.111)
        sigv1= hbar*sigv*sqrt(2) * erg2MHz;
        denominator_mat= 1i*sqrt(pi)/sigv1 * w( -energy_mat/sigv1 ); %w(z) is the Faddeeva function
    end
    tW = tV.*denominator_mat;
end

