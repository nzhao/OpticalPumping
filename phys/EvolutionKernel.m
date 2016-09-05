function drho_dt = EvolutionKernel( t, rho, atom, rate, eigen, pump )
%EVOLUTIONKERNEL Summary of this function goes here
%   Detailed explanation goes here
    %eigen   = EigenSystem(atom, condition);
    %pump    = OpticalPumping(atom, beam, condition, eigen);
    disp(t);
    dim = atom.sw.ge;
    rhoMat = reshape(rho, [dim dim]);
    exchange= SpinExchange( atom, eigen, rhoMat, eigen.S.Sj, rate);
    
    G = eigen.G + pump.G + exchange.G;
    drho_dt = -G*rho;
end

