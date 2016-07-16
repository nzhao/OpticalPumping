function levels = plotLevels( f, eigenG, eigenE, div, plt )
%PLOTLEVELS Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants;

    maxX=plt.maxX; maxY=plt.maxY;
    gs_portion=plt.gs_portion; es_portion=plt.es_portion; margin_portion=plt.margin_portion;
    level_len = plt.level_len;
    
    vDiv=div.vDiv; 
    len=0.5*level_len*(vDiv(2)-vDiv(1));
    text_dy=-1; textSize=12;
    
    levelG=hggroup;
    boxG=patch([0 maxX maxX 0], [0 0 maxY*gs_portion maxY*gs_portion], [0.6 0.6 0.9]);
    boxG.FaceAlpha=0.2;  boxG.EdgeColor='none';
    y0=normRange(0, max(eigenG.E), min(eigenG.E), maxY*gs_portion, 0, margin_portion);
    line([0 maxX], [y0 y0], 'Color', [0.7 0.7 0.7], 'LineStyle', '--', 'Parent', levelG);

    for k=1:length(f.gs.Fz)
        [x, y]=centerCoord(f, eigenG, k, div, 'G');
        line( [x-len x+len], [y y], 'Color', 'b', 'Parent', levelG);
        text( x-0.5*len, y+text_dy, num2str(eigenG.E(k)* erg2MHz, 4), 'FontSize', 12 );
    end

    
    levelE=hggroup;
    boxE=patch([0 maxX maxX 0], [maxY*(1-es_portion) maxY*(1-es_portion) maxY maxY], [0.9 0.6 0.6]);
    boxE.FaceAlpha=0.2;  boxE.EdgeColor='none';
    y0=normRange(0, max(eigenE.E), min(eigenE.E), maxY, maxY*(1-es_portion), margin_portion);
    line([0 maxX], [y0 y0], 'Color', [0.7 0.7 0.7], 'LineStyle', '--', 'Parent', levelE);
    
    for k=1:length(f.es.Fz)
        [x, y]=centerCoord(f, eigenE, k, div, 'E');
        line( [x-len x+len], [y y], 'Color', 'r', 'Parent', levelE);
        text( x-0.5*len, y+text_dy, num2str(eigenE.E(k)* erg2MHz, 4), 'FontSize', textSize );
    end
    
    levels.gs=levelG;
    levels.es=levelE;
end

