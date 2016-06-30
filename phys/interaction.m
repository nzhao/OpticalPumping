function tV=interaction(ge,gg,D,Dj,tEj)
tV=zeros(ge,gg);
for j=1:3 %sum over three Cartesian axes
    tV=tV-D*Dj(:,:,j)'*tEj(j);
end