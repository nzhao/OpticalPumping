function [br, bz] = coil_field_coaxial_pair( r, z, d, R1, I1, varargin )
%COIL_FIELD_COAXIAL_PAIR Summary of this function goes here
%   Detailed explanation goes here
    if length(varargin) == 2
        R2 = varargin{1};
        I2 = varargin{2};
    else
        R2 = R1; I2 = I1;
    end
    
    if length(r) ~= length(z)
        [rr, zz] = meshgrid(r, z);
    else
        rr = r; zz = z;
    end
    
    z1 = 0.5*d + zz; z2= -0.5*d +zz;
    [br1, bz1] = Condition.coil_field(R1, I1, rr, z1);
    [br2, bz2] = Condition.coil_field(R2, I2, rr, z2);
    br = br1 + br2;
    bz = bz1 + bz2;
end

