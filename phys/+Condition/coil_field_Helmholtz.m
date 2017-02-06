function [ br, bz ] = coil_field_Helmholtz( r, z, R0, I0, nTurn )
%COIL_FIELD_HELMHOLTZ Summary of this function goes here
%   Detailed explanation goes here
    [br0, bz0] = Condition.coil_field_coaxial_pair( r, z, R0, R0, I0 );
    br = br0 * nTurn;
    bz = bz0 * nTurn;
end

