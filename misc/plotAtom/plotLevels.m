function [ levelG, levelE ] = plotLevels( f, eigenG, eigenE, hDiv, vDiv, level_len, maxX, maxY, gs_portion, es_portion, gap_portion, margin_portion )
%PLOTLEVELS Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants;
    levelG=hggroup;
    len=0.5*level_len*(vDiv(2)-vDiv(1));
    text_dy=-1; textSize=12;
    
    y0=normRange(0, max(eigenG.E), min(eigenG.E), maxY*gs_portion, 0, margin_portion);
    line([0 maxX], [y0 y0], 'Color', [0.7 0.7 0.7], 'LineStyle', '--', 'Parent', levelG);
    for k=1:length(f.gFz)
        idxFz=round(f.gFz(k) + f.maxF + 1);
        vMid=mean([vDiv(idxFz) vDiv(idxFz+1)]);
        l= vMid-len;  r= vMid+len;
        y= normRange( eigenG.E(k), max(eigenG.E), min(eigenG.E), maxY*gs_portion, 0, margin_portion);
        line( [l r], [y y], 'Color', 'b', 'Parent', levelG);
        text( vMid-0.5*len, y+text_dy, num2str(eigenG.E(k)* erg2MHz, 4), 'FontSize', 12 );
    end
    boxG=patch([0 maxX maxX 0], [0 0 maxY*gs_portion maxY*gs_portion], [0.6 0.6 0.9]);
    boxG.FaceAlpha=0.2;  boxG.EdgeColor='none';
    
    
    levelE=hggroup;
    y0=normRange(0, max(eigenE.E), min(eigenE.E), maxY, maxY*(1-es_portion), margin_portion);
    line([0 maxX], [y0 y0], 'Color', [0.7 0.7 0.7], 'LineStyle', '--', 'Parent', levelE);
    for k=1:length(f.eFz)
        idxFz=round( f.eFz(k) + f.maxF + 1 );
        vMid=mean([vDiv(idxFz) vDiv(idxFz+1)]);
        l= vMid-len;  r= vMid+len;
        y= normRange( eigenE.E(k), max(eigenE.E), min(eigenE.E), maxY,  maxY*(1-es_portion), margin_portion);
        line( [l r], [y y], 'Color', 'r', 'Parent', levelE);
        text( vMid-0.5*len, y+text_dy, num2str(eigenE.E(k)* erg2MHz, 4), 'FontSize', textSize );
    end
    boxE=patch([0 maxX maxX 0], [maxY*(1-es_portion) maxY*(1-es_portion) maxY maxY], [0.9 0.6 0.6]);
    boxE.FaceAlpha=0.2;  boxE.EdgeColor='none';
    
end

