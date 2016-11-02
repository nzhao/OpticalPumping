function transitionFreq( obj )
%TRANSITIONFREQ Summary of this function goes here
%   Detailed explanation goes here
    obj.transFreq = cell(3,3);
    for k=1:3
        for q=1:3
            obj.transFreq{k,q} = TransitionFrequency(obj, obj.eigen.eigen_system{k}, obj.eigen.eigen_system{q}); 
        end
    end

end

