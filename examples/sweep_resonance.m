function [gammaG, diagElement, freqList] = sweep_resonance( freq, width, df, gases, pumpBeam)
%SWEEP_RESONANCE Summary of this function goes here
%   Detailed explanation goes here
    import CellSystem.VacuumCell

    freqList = freq-width:df:freq+width;
    gammaG = zeros(8, 8, length(freqList));
    for k=1:length(freqList)
        fprintf('freq = %f\n', freqList(k));
        sys=VacuumCell(gases, pumpBeam.set_detuning(freqList(k)));
        mat = sys.velocity_resolved_GammaG(3, 0);
        gammaG(:,:,k) = mat{1};
    end
    
    diagElement=zeros(8, length(freqList));
    for k=1:8
        diagElement(k, :) = reshape(gammaG(k, k, :), [1 length(freqList)]);
    end

end

