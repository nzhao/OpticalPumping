function sigma = SD_Crosssection(gas1, gas2 )
%sd_crosssection Summary of this function goes here
%   Detailed explanation goes here
    
    name_pair = [gas1.name, '-', gas2.name];
    switch name_pair
        case {'85Rb-85Rb', '85Rb-87Rb', '87Rb-85Rb', '87Rb-87Rb'}
           sigma = 1.6e-17; %cm-2
           
        case {'85Rb-N2', '87Rb-N2'}
           sigma = 1.0e-22; %cm-2
           
        case {'85Rb-4He', '87Rb-4He'}
           sigma = 9.0e-24; %cm-2
           
        case {'85Rb-129Xe', '87Rb-129Xe', '85Rb-131Xe', '87Rb-131Xe'}
           sigma = 2.0e-19; %cm-2
           
        otherwise
           error('wrong name pair %s', name_pair);
    end

end

