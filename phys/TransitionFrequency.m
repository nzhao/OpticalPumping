function [Hee,Hge,Heg,Hgg]=TransitionFrequency(atom, eigenG, eigenE)
    ge=atom.sw.ge;gg=atom.sw.gg;
    Ee=eigenE.E; Eg=eigenG.E;
    %the resonance-frequency shifts due to hyperfine splittings and applied
    %external fiels
    Hee=Ee*ones(1,ge)-ones(ge,1)*Ee'; 
    Hge=Eg*ones(1,ge)-ones(gg,1)*Ee'; 
    Heg=Ee*ones(1,gg)-ones(ge,1)*Eg'; 
    Hgg=Eg*ones(1,gg)-ones(gg,1)*Eg';
end