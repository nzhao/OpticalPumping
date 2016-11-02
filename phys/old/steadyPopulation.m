function [Nginf,Neinf]=steadyPopulation(G,LS)
rhoinf=null(G);rhoinf=rhoinf/(LS.rP*rhoinf); 
Nginf=LS.rNg*rhoinf; Neinf=LS.rNe*rhoinf; 

end