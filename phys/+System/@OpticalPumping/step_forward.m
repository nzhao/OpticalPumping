function [ new, old ] = step_forward( obj, dt )
%STEP_FORWARD Summary of this function goes here
%   Detailed explanation goes here
    old = obj.state;
    new = cell(size(old));
    for k = 1:obj.gases.nGas
        if isa(old{k}, 'Algorithm.DensityMatrix')
            new{k} = old{k}.evolve( 2*pi*obj.kernel{k}, dt );
        else
            new{k} = old{k};
        end
    end

end

