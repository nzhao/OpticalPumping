function pump = OpticalPumping( atom, beam, condition, eigen_sys )
%OPTICALPUMPINGSYSTEM Summary of this function goes here
%   Detailed explanation goes here
    
    gs_lv_dim = atom.sw.ge * atom.sw.ge;
    pump.G=zeros(gs_lv_dim, gs_lv_dim);
    S=eigen_sys.operators.S;
    
    %% Optical Pumping
    
    pump.tV=AtomPhotonInteraction(atom, beam, condition);    
    pump.effHg=EffectiveHg(atom, beam, condition);
    [pump.shift, pump.Gmp]=OpticalPumpingRate(pump.effHg);

    exchange_v = 0.5*atom.pumpR*beam.s;
    pump.G_op = RelaxationS(S, ...
                           pump.shift, ... % frequency shift
                           pump.Gmp, ...   % S-damping rate
                           pump.Gmp, ...   % S-exchange rate
                           exchange_v);   % exchange counterpart spin polarization
    
    pump.G = pump.G  + pump.G_op.sf ...
                     + pump.G_op.sd ...
                     + pump.G_op.ex;

end

