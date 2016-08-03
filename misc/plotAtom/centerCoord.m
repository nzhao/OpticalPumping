function [x, y] = centerCoord( f, eigen, k, div, state)
    maxF= 0.5*(div.n_hBlk - 1);
    if state=='G'
        boundary=div.gs_boundary;
        fz=f.gs.Fz;
    elseif state=='E'
        boundary=div.es_boundary;
        fz=f.es.Fz;
    else
        error('wrong state');
    end
    
    lb=boundary(1); ub=boundary(2); margin=boundary(3);    
    idxFz=round( fz(k) + maxF + 1 );
    x=mean([div.vDiv(idxFz) div.vDiv(idxFz+1)]);
    y= normRange( eigen.E(k), max(eigen.E), min(eigen.E), ub,  lb, margin);

end

