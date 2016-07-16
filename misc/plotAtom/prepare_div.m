function div = prepare_div( atom, plt)
%PREPARE_FIG Summary of this function goes here
%   Detailed explanation goes here
    maxX=plt.maxX; maxY=plt.maxY;
    gs_portion=plt.gs_portion; es_portion=plt.es_portion; gap_portion=plt.gap_portion;
    margin_portion=plt.margin_portion;

    n_hBlk=2+1+atom.sw.gJ;
    hDiv=zeros(1, n_hBlk+1);
    hDiv(1)=0; hDiv(2)=0.5*maxY*gs_portion; 
    hDiv(3)=maxY*gs_portion;
    
    for k=1:atom.sw.gJ+1
        hDiv(k+3)=maxY*(gs_portion+gap_portion) + maxY*(k-1)*es_portion/atom.sw.gJ;
    end
    
    hg=hggroup;
    for k=1:n_hBlk+1
        line( [0 maxX], [hDiv(k) hDiv(k)], 'Color', [0.8 0.8 0.8], 'LineStyle','--', 'Parent', hg);
    end
    
    n_vBlk=2*(atom.qn.I+atom.qn.J)+1;
    vDiv=linspace(0, maxX, n_vBlk+1); 
    
    vg=hggroup;
    for k=1:n_vBlk+1
        line( [vDiv(k) vDiv(k)],  [0 maxY], 'Color', [0.8 0.8 0.8], 'LineStyle','--', 'Parent',vg);
    end
    
    div.n_hBlk=n_hBlk; div.n_vBlk=n_vBlk;
    div.hDiv=hDiv; div.vDiv=vDiv;
    div.hg=hg; div.vg=vg;
    div.gs_boundary=[0, maxY*gs_portion, margin_portion];
    div.es_boundary=[maxY*(1-es_portion), maxY, margin_portion];
end

