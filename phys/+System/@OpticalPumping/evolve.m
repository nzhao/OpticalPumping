function evolve( obj, maxT, nt )
%EVOLVE Summary of this function goes here
%   Detailed explanation goes here
    dt = maxT / (nt-1);            
    record = cell(1, nt);

    k = 1;
    while k <= nt
        fprintf( 'evolving %d\n', k);
        [obj.state, record{k}] = obj.step_forward(dt);
        obj.update_kernel();
        k = k +1;
    end
    obj.result.time  = linspace(0, maxT, nt);
    obj.result.state = record;
end

