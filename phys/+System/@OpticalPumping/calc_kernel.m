function calc_kernel( obj, mode )
%CALC_KER Summary of this function goes here
%   Detailed explanation goes here
    if nargin < 2
        mode = 'update';
    end
    
    for k=1:obj.gases.nGas
        if strcmp(mode, 'init')
            obj.process.g0_term{k} = obj.gases.calc_g0_term( k );
            obj.process.sd_term{k} = obj.gases.calc_sd_term( k );
            obj.process.op_term{k} = obj.gases.calc_op_term( k );
        end
        obj.process.se_term{k} = obj.gases.calc_se_term( k, obj.state );
        obj.process.sr_term{k} = obj.gases.calc_sr_term( k, obj.state );
        

        obj.kernel{k} = obj.process.sd_term{k} ...
                      + obj.process.se_term{k} ...
                      + obj.process.sr_term{k} ...
                      + obj.process.op_term{k};
    end  
end

