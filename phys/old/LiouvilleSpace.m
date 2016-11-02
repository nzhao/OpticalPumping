function LS=LiouvilleSpace(atom)
gg=atom.sw.gg;ge=atom.sw.ge;
%[gt,Pe,Pg,cPe,rPe,cPg,rPg,cNe,rNe,cNg,rNg,LrNe,LrNg,cP,rP]=LiouvilleSpace(gg,ge)
%gt:dimension of full Liouville space
%Pe,Pg:excited and ground states' projection operators
%column vectors:cPe,cPg...; row vectors:rPe,rPg...
%the probabilities for finding the atom in excited or ground state:cNe,rNe,cNg,rNg
%LrNe,LrNg:logical variables for the populations of excited and ground states
LS.Pg=eye(gg); LS.Pe=eye(ge);%projection operators 
LS.cPe=LS.Pe(:); LS.rPe=LS.cPe'; LS.cPg=LS.Pg(:); LS.rPg=LS.cPg(:)'; 
LS.gt=(gg+ge)^2;%dimension of full Liouville space 
LS.cNe=[LS.cPe;zeros(LS.gt-ge*ge,1)]; LS.rNe=LS.cNe'; LS.LrNe=logical(LS.rNe); 
LS.cNg=[zeros(LS.gt-gg*gg,1); LS.cPg];LS.rNg=LS.cNg'; LS.LrNg=logical(LS.rNg); 
LS.cP=LS.cNe+LS.cNg; LS.rP=LS.rNe+LS.rNg; 
end