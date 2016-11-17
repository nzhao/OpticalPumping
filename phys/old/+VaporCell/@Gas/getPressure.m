function p = getPressure( obj, temperature )
%GETPRESSURE Summary of this function goes here
%   Detailed explanation goes here
    switch obj.atom.name
            
        case {'85Rb', '87Rb'}
            if temperature <= obj.atom.parameters.Tmelt
                p=10^(2.881+4.857-4215/temperature)*Torr2Pa;
            else
                p=10^(2.881+4.312-4040/temperature)*Torr2Pa;
            end
            
        case '133Cs'
            if temperature <= obj.atom.parameters.Tmelt
                p=10^(2.881+4.711-3999/temperature)*Torr2Pa;
            else
                p=10^(2.881+4.165-3830/temperature)*Torr2Pa;
            end
            
        otherwise
            error('atom name %s not supported.', obj.atom.name);
    end

end

