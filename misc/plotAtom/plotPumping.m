function fig = plotPumping( atom, magB )
%PLOTLEVELS Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants;
    fig=figure; ax=gca;
    %ax.Position=[0 0 1 1]; 
    ax.Position=[0.05 0.05 0.9 0.9]; 
    %ax.XTick=[]; ax.XColor='w';
    %ax.YTick=[]; ax.YColor='w';
    hold on;
    
    maxX=100; maxY=100;
    ax.XLim=[0 maxX]; ax.YLim=[0 maxY];
    gs_portion=0.3; es_portion=0.3; gap_portion=0.4;
    
    [ hDiv, vDiv, hg, vg ] = prepare_div( atom, maxX, maxY, gs_portion, es_portion, gap_portion);
    hg.Visible='off';  vg.Visible='on';
    
    f=qnF(atom, magB);
    H=Hamiltonian(atom, magB);
    eigenG=eigH(H.uHg);  eigenE=eigH(H.uHe);
    
    level_len=0.8; margin_portion=0.2;
    [levelG, levelE] = plotLevels( f, eigenG, eigenE, hDiv, vDiv, level_len, maxX, maxY, gs_portion, es_portion, gap_portion, margin_portion );
    levelG.Visible='on'; levelE.Visible='on';

    
end

