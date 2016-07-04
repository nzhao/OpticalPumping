function Acgg=relaxation(atom,LS)
%uniform-relaxation matrix, Eq. 5.111
    Acgg=eye(atom.sw.gg*atom.sw.gg)-LS.cPg*LS.rPg/atom.sw.gg;
end