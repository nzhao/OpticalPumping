function fig = plotPumping( atom, beam, magB )
%PLOTLEVELS Summary of this function goes here
%   Detailed explanation goes here
    fundamental_constants;
    
    plt.maxX=100; plt.maxY=100;
    plt.gs_portion=0.3; plt.es_portion=0.3; plt.margin_portion=0.2;
    plt.gap_portion=1-plt.gs_portion-plt.es_portion;
    plt.level_len=0.8; 

    fig=figure; ax=gca; hold on;

    ax.Position=[0.05 0.05 0.9 0.9];  %ax.XTick=[]; ax.XColor='w';    %ax.YTick=[]; ax.YColor='w';
    ax.XLim=[0 plt.maxX]; ax.YLim=[0 plt.maxY];

    div = prepare_div( atom, plt);
    div.hg.Visible='off';  div.vg.Visible='on';
    
    f=qnF(atom, magB);
    H=Hamiltonian(atom, magB);
    eigenG=eigH(H.uHg);  eigenE=eigH(H.uHe);
    Dj=dipoleOperator(eigenG.U,eigenE.U,atom);
    tV=interaction(atom, beam, Dj);
    tV1=tV./norm(tV);
    disp(tV1);
    
    levels = plotLevels( f, eigenG, eigenE, div, plt );
    levels.gs.Visible='on'; levels.es.Visible='on';

    for i=1:atom.sw.gg
        for j=1:atom.sw.ge
            [x1 y1] = centerCoord(f, eigenG, i, div, 'G');
            [x2 y2] = centerCoord(f, eigenE, j, div, 'E');
            if abs(tV1(j,i)) > 1e-5
                line( [x1 x2], [y1 y2]);
            end
        end
    end
    
end

