function tV=interaction(atom,beam,Dj)
ge=atom.sw.ge;gg=atom.sw.gg;D=atom.D;tEj=beam.tEj;
tV=zeros(ge,gg);
for j=1:3 %sum over three Cartesian axes
    tV=tV-D*Dj(:,:,j)'*tEj(j);
end