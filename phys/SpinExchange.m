function exchange = SpinExchange( atom, eigen, rho, S_operator, rate)
%SPINEXCHANGE Summary of this function goes here
%   Detailed explanation goes here
    
    gs_lv_dim = atom.sw.ge * atom.sw.ge;
    exchange.G=zeros(gs_lv_dim, gs_lv_dim);
    S=eigen.operators.S;

    %% Spin exchange
    exchange.shift = rate.shift;
    exchange.SD = rate.damping;
    exchange.SE = rate.exchange;

    v(1) = rho'*S_operator.lv(:, 1);
    v(2) = rho'*S_operator.lv(:, 2);
    v(3) = rho'*S_operator.lv(:, 3);
    
    exchange.G_op = RelaxationS(S, ...
                           exchange.shift, ... % frequency shift
                           exchange.SD, ...   % S-damping rate
                           exchange.SE, ...   % S-exchange rate
                           0.25*v);   % exchange counterpart spin polarization
    
    exchange.G = exchange.G  + exchange.G_op.sf ...
                             + exchange.G_op.sd ...
                             + exchange.G_op.ex;
end

