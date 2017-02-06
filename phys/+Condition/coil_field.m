function [ br, bz ] = coil_field( R0, I0, r, z )
%COIL_FIELD Summary of this function goes here
%   Detailed explanation goes here
%   input parameters: R0 - coil radius in [m]
%                     I0 - current in [A]
%                     r, z - column coordinates in [m]
%   output:           br, bz - field in [Tesla]

        a = (R0*R0 + r.*r + z.*z)./(2*r*R0);  
        aM = a-1; aP = a+1;
        c = 1./sqrt(8*r.^3.*R0);

        aM2 = -2./(aM+eps);
        intE = ellipticE(pi/4, aM2) + ellipticE(3*pi/4, aM2);
        intF = ellipticF(pi/4, aM2) + ellipticF(3*pi/4, aM2);

        int1 = 2*intE ./ sqrt(aM) ./ aP;
        int2 = 2*(a.*intE - aP.*intF)./sqrt(aM)./aP;
    
        br = mu0/4/pi*I0 * c .* z.*int2;
        bz = mu0/4/pi*I0 * c .* (R0*int1 - r.*int2);

        bzAxis = mu0/2*I0 * R0*R0 ./ power( R0*R0 + z.*z, 1.5);
        br(r==0) = 0;
        bz(r==0) = bzAxis(r==0);
end

