function exchange = SpinExchange( atom, eigen, rho, smat, rate)
%SPINEXCHANGE Summary of this function goes here
%   Detailed explanation goes here
    
    gs_lv_dim = atom.sw.ge * atom.sw.ge;
    exchange.G=zeros(gs_lv_dim, gs_lv_dim);
    S=eigen.S;

    %% Spin exchange
    exchange.shift = rate.shift;
    exchange.SD = rate.damping;
    exchange.SE = rate.exchange;

    v(1) = trace(rho*smat(:,:,1));
    v(2) = trace(rho*smat(:,:,2));
    v(3) = trace(rho*smat(:,:,3));
    
    exchange.G_op = RelaxationS(S, ...
                           exchange.shift, ... % frequency shift
                           exchange.SD, ...   % S-damping rate
                           exchange.SE, ...   % S-exchange rate
                           0.025*v);   % exchange counterpart spin polarization
    
    exchange.G = exchange.G  + exchange.G_op.sf ...
                             + exchange.G_op.sd ...
                             + exchange.G_op.ex;
end

