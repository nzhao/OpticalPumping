classdef OpticalPumping < handle
    %OPTICALPUMPING Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        gases
        beam
        
        state
        kernel
        process
        
        result
    end
    
    methods
        function obj = OpticalPumping(gases, beam)
            obj.gases = gases;
            obj.beam = beam;
            
            obj.gases.set_pumping_rate(beam);
            
            for k=1:obj.gases.nGas
                atom = obj.gases.gasList{k}.atom;
                if atom.hasSpin
                    obj.state{k} = Algorithm.DensityMatrix(atom);
                else
                    obj.state{k} = [];
                end
            end
            
            obj.process.sd_term = cell(1, obj.gases.nGas);
            obj.process.se_term = cell(1, obj.gases.nGas);
            obj.process.sr_term = cell(1, obj.gases.nGas);
            obj.process.op_term = cell(1, obj.gases.nGas);
            obj.kernel = cell(1, obj.gases.nGas);

            obj.calc_kernel('init');
        end
        
        function atom = get_atom(obj, k)
            atom = obj.gases.gasList{k}.atom;
        end
        
        function update_kernel(obj)
            obj.calc_kernel('update');
        end
    end
    
end

