function eHg = EffectiveHg(atom, beam, condition)
%EFFEHG Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants
    
    H=Hamiltonian(atom,condition);  %Hamiltonian
    
    eigenG=Diagnalize(H.uHg);
    eigenE=Diagnalize(H.uHe);
    [~,~,Heg,~]=TransitionFrequency(atom, eigenG, eigenE);

    tV=AtomPhotonInteraction(atom, beam, condition);
    
    if ~ isfield(condition, 'temperature')
        condition.temperature=0.0;
    end
    denomMat=DenominatorMat(atom, beam, condition, tV, Heg);
    eHg = -tV'*(tV.*denomMat);
end

