function p = getPressure( obj, temperature )
%GETPRESSURE Summary of this function goes here
%   Detailed explanation goes here
    switch obj.name
        case '87Rb'
            p=1.0*temperature;
        case '133Cs'
            p=1.0*temperature;
        otherwise
            error('atom name %s not supported.', obj.name);
    end

end

