function res = plotPumping( atom, beam, magB, rho )
%PLOTLEVELS Summary of this function goes here
%   Detailed explanation goes here
    
    fundamental_constants;
    
    plt.maxX=100; plt.maxY=100;
    plt.gs_portion=0.3; plt.es_portion=0.3; plt.margin_portion=0.2;
    plt.gap_portion=1-plt.gs_portion-plt.es_portion;
    plt.level_len=0.8; 

    clf;
    ax=gca; hold on;

    ax.Position=[0.05 0.10 0.9 0.85];  %ax.XTick=[]; ax.XColor='w';    %ax.YTick=[]; ax.YColor='w';
    ax.XLim=[0 plt.maxX]; ax.YLim=[0 plt.maxY];

    div = prepare_div( atom, plt);
    div.hg.Visible='off';  div.vg.Visible='on';
    
    f=qnF(atom, magB);
    H=Hamiltonian(atom, magB);
    eigenG=eigH(H.uHg);  eigenE=eigH(H.uHe);
    Dj=dipoleOperator(eigenG.U,eigenE.U,atom);
    tV=interaction(atom, beam, Dj);

    for i=1:atom.sw.gg
       [x1, y1] = centerCoord(f, eigenG, i, div, 'G');
       plot(x1, y1, 'Marker', 'o', 'MarkerSize', 200*abs(rho(i,i)), 'MarkerFaceColor', 'b', 'MarkerEdgeColor', 'b');
       text(x1+2, y1+1, sprintf('pop=%3.2f%%', 100*rho(i,i)) );
    end
    for i=1:atom.sw.ge
       [x1, y1] = centerCoord(f, eigenE, i, div, 'E');
       plot(x1, y1, 'Marker', 'o', 'MarkerSize', 200*abs(rho(atom.sw.gg+i,atom.sw.gg+i))+eps, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r');
       text(x1+2, y1+1, sprintf('pop=%3.2f%%', 100*rho(atom.sw.gg+i,atom.sw.gg+i)) );
    end
    
    tiny=1e-3;
    tV1=( tV./max(abs(tV(:))) ).^2; tV1(abs(tV1)<tiny)=0;
    for i=1:atom.sw.gg
        for j=1:atom.sw.ge
            [x1, y1] = centerCoord(f, eigenG, i, div, 'G');
            [x2, y2] = centerCoord(f, eigenE, j, div, 'E');
            if abs(tV1(j,i)) > 0.2
                line( [x1 x2], [y1 y2], 'LineWidth', tV1(j, i)*5 ,'Color', 'm');
                text( mean([x1 x2]), mean([y1 y2]), num2str(tV1(j, i), 4) );
            elseif abs(tV1(j,i)) > 0
                line( [x1 x2], [y1 y2], 'LineWidth', tV1(j, i)*5 ,'Color', 'm', 'LineStyle', '--');
                text( mean([x1 x2]), mean([y1 y2]), num2str(tV1(j, i), 4) );
            end
        end
    end
    
    levels = plotLevels( f, eigenG, eigenE, div, plt );
    levels.gs.Visible='on'; levels.es.Visible='on';
        
    res.tV1 = tV1;
    res.rho = rho;
    
    hold off;
end

