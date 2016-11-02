function state = steady_state( obj, dt, maxN, eps0 )
%STEADY_STATE Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 3
        maxN = inf;
        eps0 = 1e-10;
    end
    if nargin < 4
        eps0 = 1e-10;
    end
    
    k = 1; diff = 1;
    while k < maxN && diff > eps0
        %fprintf( 'evolving %d, diff=%5.2e\n', k, diff);
        [new_state, old_state] = obj.step_forward(dt);
        obj.state = new_state;
        obj.update_kernel();
        k = k +1;

        diff = 0;
        for q = 1:obj.gases.nGas
            diff = diff + norm(new_state{q} - old_state{q});
        end
    end
    fprintf('%d steps\n', k);
    state = new_state;
end

