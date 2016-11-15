function sw=statistical_weights(I,S,J);
%statistical weights gI, gS, gJ, gg, ge
sw.gI=2*I+1; sw.gS=2*S+1; sw.gJ=2*J+1; 
sw.gg=sw.gI*sw.gS; sw.ge=sw.gI*sw.gJ;
end